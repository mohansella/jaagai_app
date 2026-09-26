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

  final allowedUrls = {
    "https://jaagai.online/login.php",
    "https://jaagai.online/register.php",
    "https://jaagai.online/matrimony-search.php",
    //"https://jaagai.online/contact-us.php",
    "https://jaagai.online/logout.php",
    "https://jaagai.online/profile.php",
    "https://jaagai.online/uploads",
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
      ..loadRequest(Uri.parse('https://jaagai.online/login.php'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jaagai Online',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: WebViewWidget(controller: controller)),
    );
  }
}
