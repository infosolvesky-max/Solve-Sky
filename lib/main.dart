// main.dart ফাইল-এর জন্য WebView কোড
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// আপনার ওয়েবসাইটের নাম: Solve Sky.
const String solveSkyUrl = "https://www.solvesky.com"; // এখানে আপনার আসল ওয়েবসাইটের ঠিকানা দিন।

void main() {
  runApp(const SolveSkyApp());
}

class SolveSkyApp extends StatelessWidget {
  const SolveSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solve Sky App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Loading progress দেখানোর জন্য কোড
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            // এরর দেখালে
          },
        ),
      )
      ..loadRequest(Uri.parse(solveSkyUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve Sky'),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}