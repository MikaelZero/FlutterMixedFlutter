import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatelessWidget {
  final String url;
  final String title;

  WebViewPage(this.url, {Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
    );
  }
}
