import 'dart:collection';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';

import '../../utils/global.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    Key? key,
    required this.url,
    this.onWebProgress,
    this.onWebResourceError,
    required this.onLoadFinished,
    required this.onWebTitleLoaded,
    this.onWebViewCreated,
  }) : super(key: key);

  final String url;
  final Function(int progress)? onWebProgress;
  final Function(String? errorMessage)? onWebResourceError;
  final Function(String? url) onLoadFinished;
  final Function(String? webTitle)? onWebTitleLoaded;
  final Function(InAppWebViewController controller)? onWebViewCreated;

  @override
  State<WebViewPage> createState() => _WebViewPage();
}

class _WebViewPage extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewOptions viewOptions = InAppWebViewOptions(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: true,
    applicationNameForUserAgent: "dface-yjxdh-webview",
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    webViewController?.clearCache();
    super.dispose();
  }

  // 设置页面标题
  void setWebPageTitle(data) {
    if (widget.onWebTitleLoaded != null) {
      widget.onWebTitleLoaded!(data);
    }
  }

  // flutter调用H5方法
  void callJSMethod() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        toolbarHeight: 40.0,
        title: Text("家缘后台管理"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialUrlRequest:
              URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
              initialUserScripts: UnmodifiableListView<UserScript>([
                UserScript(
                    source:
                    "document.cookie='token=${Global.token};domain='.laileshuo.cb';path=/'",
                    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
              ]),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: viewOptions,
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;

                if (widget.onWebViewCreated != null) {
                  widget.onWebViewCreated!(controller);
                }
              },
              onTitleChanged: (controller, title) {
                if (widget.onWebTitleLoaded != null) {
                  widget.onWebTitleLoaded!(title);
                }
              },
              onLoadStart: (controller, url) {},
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                // 允许路由替换
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                // 加载完成
                widget.onLoadFinished(url.toString());
              },
              onProgressChanged: (controller, progress) {
                if (widget.onWebProgress != null) {
                  widget.onWebProgress!(progress);
                }
              },
              onLoadError: (controller, Uri? url, int code, String message) {
                if (widget.onWebResourceError != null) {
                  widget.onWebResourceError!(message);
                }
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {},
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),
          ),
          Container(
            height: ScreenUtil().bottomBarHeight + 50.0,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          WidgetStateProperty.all(AppColors.appColor),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          webViewController?.goBack();
                        },
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          WidgetStateProperty.all(AppColors.appColor),
                        ),
                        child: Icon(Icons.arrow_forward,color: Colors.white,),
                        onPressed: () {
                          webViewController?.goForward();
                        },
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          WidgetStateProperty.all(AppColors.appColor),
                        ),
                        child: Icon(Icons.refresh,color: Colors.white,),
                        onPressed: () {
                          // callJSMethod();
                          webViewController?.reload();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil().bottomBarHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
