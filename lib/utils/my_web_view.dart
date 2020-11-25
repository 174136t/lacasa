import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:lacasa/utils/loader.dart';

class MyWebView extends StatefulWidget {
  final String url;
  MyWebView({@required this.url});
  @override
  _MyWebViewState createState() => _MyWebViewState(url: url);
}

class _MyWebViewState extends State<MyWebView> {
  _MyWebViewState({@required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: url,
        appBar: new AppBar(
          elevation: 0,
          // backgroundColor: Colors.white54.withOpacity(0.9),
          title: const Text('LACASA'),
          toolbarHeight: 40,
          shape: RoundedRectangleBorder(side: BorderSide(width: 0.5)),
        ),
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
            color: Colors.white,
            child: Center(
              child: MyLoader(),
            )));
  }
}
