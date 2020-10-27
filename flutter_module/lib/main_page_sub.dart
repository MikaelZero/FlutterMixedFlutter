import 'dart:async';
import 'dart:collection';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/pages/router_manager.dart';

import 'flutter_plugin_batterylevel.dart';

class MainPageRouter {
  static const titleArr = [
    "Open WebView",
    "Invoke Native API",
    "Send Message to Android from Flutter",
    "Invoke Flutter API",
    "Send Message to Flutter from Android",
    "EventChannel(flutter listen android)"
  ];

  static const routerArr = [
    RouteName.webViewChoose,
    RouteName.invokeNativeApi,
    RouteName.sendMsgToAndroid,
    "",
    RouteName.sendMsgToFlutter,
    ""
  ];

  MainPageRouter.launchRouter(BuildContext context, int position) {
    if (position == 2) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.RUN',
        package: 'net.mikaelzero.fluttersample',
        componentName: 'net.mikaelzero.fluttersample.GetResultActivity',
      );
      intent.launch();
    } else if (position == 3) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.RUN',
        package: 'net.mikaelzero.fluttersample',
        componentName: 'net.mikaelzero.fluttersample.InvokeFlutterActivity',
      );
      intent.launch();
    } else if (position == 5) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.RUN',
        package: 'net.mikaelzero.fluttersample',
        componentName: 'net.mikaelzero.fluttersample.EventChannelActivity',
      );
      intent.launch();
    } else {
      Navigator.of(context).pushNamed(routerArr[position]);
    }
  }
}

class WebViewChoose extends StatefulWidget {
  WebViewChoose({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<WebViewChoose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView Choose"),
      ),
      body: ListView(children: _getListData()),
    );
  }

  List<Widget> _getListData() {
    List<Widget> widgets = [];
    widgets.add(GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
            "Open WebView with Flutter From Android\n(Enter into Android Page)"),
      ),
      onTap: () {
        AndroidIntent intent = AndroidIntent(
          action: 'android.intent.action.RUN',
          package: 'net.mikaelzero.fluttersample',
          componentName: 'net.mikaelzero.fluttersample.FlutterHomeActivity',
          arguments: {'route': '/routeName'},
        );
        intent.launch();
      },
    ));
    widgets.add(GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Open WebView with Flutter From Flutter"),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(RouteName.webViewPage);
      },
    ));
    return widgets;
  }
}

class SendMsgToFlutter extends StatefulWidget {
  SendMsgToFlutter({Key key}) : super(key: key);

  @override
  SendMsgToFlutterState createState() => SendMsgToFlutterState();
}

class SendMsgToFlutterState extends State<SendMsgToFlutter> {
  static const basicMessageChannel = BasicMessageChannel(
      'messageChannelForAndroidToFlutter', StandardMessageCodec());
  var _messageFromNative =
      "this message will change to another which is receive from android";

  @override
  void initState() {
    super.initState();
    _listenMessageFromNative();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SendMsgToFlutter"),
      ),
      body: Center(
        child: GestureDetector(
          child: Center(
            child: Text(
              "this is flutter page \n click to android page \n($_messageFromNative)",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
          onTap: () {
            AndroidIntent intent = AndroidIntent(
              action: 'android.intent.action.RUN',
              package: 'net.mikaelzero.fluttersample',
              componentName: 'net.mikaelzero.fluttersample.SendMessageActivity',
            );
            intent.launch();
          },
        ),
      ),
    );
  }

  void _listenMessageFromNative() {
    basicMessageChannel.setMessageHandler(_receiveMessageFromNative);
  }

  Future<dynamic> _receiveMessageFromNative(Object result) async {
    setState(() {
      _messageFromNative = result.toString();
    });
  }
}

class InvokeNativeApiWidget extends StatefulWidget {
  InvokeNativeApiWidget({Key key}) : super(key: key);

  @override
  InvokeNativeApiPageState createState() => InvokeNativeApiPageState();
}

class InvokeNativeApiPageState extends State<InvokeNativeApiWidget> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterPluginBatterylevel.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoke Native Api"),
      ),
      body:
      Center(child: Text("get android platformVersion:$_platformVersion")),
    );
  }
}

// flutter send msg to android
class SendMsgToAndroid extends StatefulWidget {
  SendMsgToAndroid({Key key}) : super(key: key);

  @override
  SendMsgToAndroidState createState() => SendMsgToAndroidState();
}

class SendMsgToAndroidState extends State<SendMsgToAndroid> {
  static const basicMessageChannel = BasicMessageChannel(
      'messageChannelForFlutterToAndroid', StandardMessageCodec());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SendMsgToAndroid"),
      ),
      body: Center(
        child: GestureDetector(
          child: Center(
            child: Text(
                "this is flutter page\n click go to android page \n and send message to android"),
          ),
          onTap: () {
            HashMap map = new HashMap();
            map["data"] = "this data is from flutter page";
            toolsBasicChannelMethodWithParams(map);
            SystemNavigator.pop();
          },
        ),
      ),
    );
  }

  /*
 * BasicMessageChannel
 * 实现Flutter 调用Android iOS原生方法并回调
 * arguments 发送给原生的参数 ,自定义基本数据格式{"method": "test", "content": "flutter 中的数据", "code": 100}
 * return数据 原生发给Flutter的参数,自定义基本数据格式{"code":100,"message":"消息","content":内容}
 */
  Future<Map> toolsBasicChannelMethodWithParams(Map arguments) async {
    var result;
    try {
      result = await basicMessageChannel.send(arguments);
    } catch (e) {
      result = {'Failed': e.message};
    }
    return result;
  }
}

class ListenAndroid extends StatefulWidget {
  ListenAndroid({Key key}) : super(key: key);

  @override
  ListenAndroidState createState() => ListenAndroidState();
}

class ListenAndroidState extends State<ListenAndroid> {
  static const stream = const EventChannel("eventChannelAndroidToFlutter");
  StreamSubscription _timerSubscription;
  var _timer = "this is default value";

  @override
  void initState() {
    super.initState();
    _enableTimer();
  }
  @override
  void dispose() {
    super.dispose();
    _disableTimer();
  }

  void _enableTimer() {
    if (_timerSubscription == null) {
      _timerSubscription = stream.receiveBroadcastStream().listen(_updateTimer);
    }
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  void _updateTimer(timer) {
    setState(() => _timer = timer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SendMsgToAndroid"),
      ),
      body: Center(
        child: GestureDetector(
          child: Center(
            child: Text(_timer),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
