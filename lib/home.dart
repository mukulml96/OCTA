import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'config.dart';

class Home extends StatefulWidget {
  final String url;

  Home(this.url);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController webViewController;
  bool isLoading = true;
  String url = Config.APP_URL;
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getUrl();
    // });

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  // getUrl() async {
  //   String urlSP = await SharedPreferencesHelper.getUrl();
  //   setState(() {
  //     url = urlSP;
  //   });
  //   print(url);
  // }

  // _buildinitiPop() async {
  //   return showGeneralDialog(
  //     barrierDismissible: true,
  //     barrierLabel: '',
  //     barrierColor: Colors.white.withOpacity(0.2),
  //     transitionDuration: Duration(milliseconds: 200),
  //     pageBuilder: (ctx, anim1, anim2) => AlertDialog(
  //         contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         content: UrlSelector()),
  //     context: context,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // getUrl();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Color(0XFF7cc576)));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(45, 0, 0, 15),
      //       child: SizedBox(
      //         height: 40,
      //         width: 40,
      //         child: FloatingActionButton(
      //           backgroundColor: Colors.white.withOpacity(0.8),
      //           onPressed: () {
      //             // _buildinitiPop();
      //           },
      //           child: Icon(
      //             FontAwesomeIcons.link,
      //             color: Colors.black54,
      //             size: 20,
      //           ),
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10)),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                WebView(
                  debuggingEnabled: true,
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    this.webViewController = webViewController;
                  },
                  javascriptChannels: <JavascriptChannel>[
                    _toasterJavascriptChannel(context),
                  ].toSet(),
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                    setState(() {
                      isLoading = true;
                    });
                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    webViewController.evaluateJavascript(
                        "var meta = document.getElementsByTagName('meta');"
                        "for (var i = 0; i < meta.length; i++) {"
                        "if (meta[I].attribute('name') == null) continue;"
                        "if (meta[i].attribute('name').includes('viewport')) {"
                        "document.getElementsByTagName('meta')[i].remove();"
                        "break;"
                        "}"
                        "}"
                        "document.getElementsByTagName('head')[0].innerHTML += "
                        "\"<meta name='viewport' content='viewport-fit=cover, width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'/>\";");
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onWebResourceError: (error) {
                    print(error);
                  },
                  gestureNavigationEnabled: true,
                ),
                isLoading
                    ? Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    "assets/bg.png",
                                  ))),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 150,
                                    child: Image.asset("assets/logo.png")),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: 
                                  
                                  SpinKitDualRing(color: Color(0XFF7cc576),
                                  size: 20,
                                  )
                                 
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Stack(),
              ],
            );
          },
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
          print("SnackBar");
        });
  }
}
