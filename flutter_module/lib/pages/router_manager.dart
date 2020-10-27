import 'package:flutter/material.dart';
import 'package:flutter_module/main_page_sub.dart';
import 'package:flutter_module/pages/page_route_anim.dart';
import 'package:flutter_module/web_view_page.dart';

class RouteName {
  static const String splash = 'splash';
  static const String webViewChoose = 'webViewChoose';
  static const String webViewPage = 'webViewPage';
  static const String sendMsgToFlutter = 'sendMsgToFlutter';
  static const String invokeNativeApi = 'invokeNativeApi';
  static const String sendMsgToAndroid = 'sendMsgToAndroid';
  static const String listenAndroid = 'listenAndroid';
  static const String tab = '/';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.webViewChoose:
        return FadeRouteBuilder(WebViewChoose());
      case RouteName.webViewPage:
        return NoAnimRouteBuilder(WebViewPage(
          "https://www.yuque.com/mikaelzero/blog",
          title: "MikaelZero Blog",
        ));
      case RouteName.sendMsgToFlutter:
        return FadeRouteBuilder(SendMsgToFlutter());
      case RouteName.sendMsgToAndroid:
        return FadeRouteBuilder(SendMsgToAndroid());
      case RouteName.invokeNativeApi:
        return FadeRouteBuilder(InvokeNativeApiWidget());
      case RouteName.listenAndroid:
        return FadeRouteBuilder(ListenAndroid());
      default:
        return NoAnimRouteBuilder(WebViewPage("", title: ""));
    }
  }
}

