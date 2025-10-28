// ফাইল: lib/main.dart

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const SolveSkyApp());
}

class SolveSkyApp extends StatelessWidget {
  const SolveSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Solve Sky',
      home: WebViewScreen(),
      debugShowCheckedModeBanner: false, // ডানদিকের debug ব্যানার মুছে দেবে
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  static const String _homeUrl = 'https://solvesky.com';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(_homeUrl));
  }

  // **ব্যাক বাটন লজিক**
  Future<bool> _onWillPop() async {
    // যদি WebView-তে ফিরে যাওয়ার হিস্টোরি থাকে, তাহলে আগের পেজে ফিরে যাও
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false); // অ্যাপ বন্ধ হবে না
    } 
    // যদি হিস্টোরি না থাকে, তাহলে অ্যাপটি বন্ধ হবে
    else {
      return Future.value(true); // অ্যাপ বন্ধ হবে
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        body: SafeArea( // স্ট্যাটাস বারের নিচে থেকে WebView শুরু হবে
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
