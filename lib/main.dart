import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WebViewController controller;

  static const jaagaiDomain = kReleaseMode
      ? "https://jaagai.online"
      : "http://localhost:8080";

  final allowedUrls = {
    "$jaagaiDomain/new/login.php",
    "$jaagaiDomain/new/register.php",
    "$jaagaiDomain/new/matrimony-search.php",
    "$jaagaiDomain/new/logout.php",
    "$jaagaiDomain/new/profile.php",
  };

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            print('pageStart :$url');
          },
          onPageFinished: (String url) {
            print('pageFinished :$url');
          },
          onHttpError: (HttpResponseError error) {
            print('error: $error');
          },
          onWebResourceError: (WebResourceError error) {
            print('reserror: $error');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('req: ${request.url}');
            if (allowedUrls.any((allowed) => request.url.startsWith(allowed))) {
              return .navigate;
            }
            print('preventing req: ${request.url}');
            launchUrl(Uri.parse(request.url));
            return .prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse('$jaagaiDomain/new/login.php'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jaagai Online',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(child: WebViewWidget(controller: controller)),
      ),
    );
  }
}
