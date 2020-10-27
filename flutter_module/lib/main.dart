import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main_page_sub.dart';
import 'pages/router_manager.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Router.generateRoute,
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = <Widget>[];
  var platform = const MethodChannel("invokeFlutterMethodName");

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < MainPageRouter.titleArr.length; i++) {
      widgets.add(getRow(i));
    }
    platform.setMethodCallHandler(platformCallHandler);
  }

  Future<dynamic> platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "getName":
        return "Flutter name from flutter method";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sample App"),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: widgets.length,
              itemBuilder: (BuildContext context, int position) {
                return getRow(position);
              }),
        ));
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          MainPageRouter.titleArr[i],
          style: TextStyle(fontSize: 25),
        ),
      ),
      onTap: () {
        MainPageRouter.launchRouter(context, i);
      },
    );
  }
}
