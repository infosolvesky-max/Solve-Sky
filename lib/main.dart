// ফাইল: lib/main.dart
// সংস্করণ ২.০: ফাইল আপলোড এবং লোডিং ইন্ডিকেটর কার্যকারিতা যুক্ত করা হয়েছে।

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ছবি তোলার জন্য নতুন প্যাকেজ
import 'package:webview_flutter/webview_flutter.dart';
// অ্যান্ড্রয়েডের বিশেষ ক্ষমতার জন্য এই প্যাকেজটি যোগ করা হয়েছে
import 'package:webview_flutter_android/webview_flutter_android.dart';

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
      debugShowCheckedModeBanner: false,
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
  
  // কাজ ৩: ব্যবহারকারীর অভিজ্ঞতা উন্নত করার জন্য নতুন ভ্যারিয়েবল
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // WebView Controller-কে আরও শক্তিশালী করা হয়েছে
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      // কাজ ৩: পেজ লোডিং ট্র্যাক করার জন্য Navigation Delegate যোগ করা হয়েছে
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true; // পেজ লোড শুরু হলে লোডিং ইন্ডিকেটর দেখাও
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false; // পেজ লোড শেষ হলে লোডিং ইন্ডিকেটর লুকান
            });
          },
          onWebResourceError: (WebResourceError error) {
            // ভবিষ্যতে কোনো এরর হলে এখানে তা পরিচালনা করা যাবে
          },
        ),
      )
      ..loadRequest(Uri.parse(_homeUrl));

    // কাজ ১: ফাইল আপলোড কার্যকারিতা চালু করার মূল কোড
    _setupFileUpload();
  }

  // এই ফাংশনটি WebView-কে ফাইল আপলোডের ক্ষমতা দেয়
  void _setupFileUpload() {
    if (_controller.platform is AndroidWebViewController) {
      final androidController = _controller.platform as AndroidWebViewController;
      androidController.setOnShowFileChooser((params) async {
        // ImagePicker ব্যবহার করে ফোনের গ্যালারি খোলা হবে
        final picker = ImagePicker();
        final photo = await picker.pickImage(source: ImageSource.gallery);

        if (photo != null) {
          // ব্যবহারকারী যদি কোনো ছবি বেছে নেন, তাহলে তার পাথ WebView-কে ফেরত দেওয়া হবে
          return [Uri.file(photo.path).toString()];
        }
        // যদি ব্যবহারকারী কিছু না বেছে নেন, তাহলে একটি খালি তালিকা ফেরত দেওয়া হবে
        return [];
      });
    }
  }

  // **ব্যাক বাটন লজিক (অপরিবর্তিত)**
  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
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
        // কাজ ৩: Stack ব্যবহার করে WebView-এর উপরে লোডিং ইন্ডিকেটর দেখানো হচ্ছে
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              // যদি পেজ লোড হতে থাকে, তাহলে এই স্পিনারটি দেখা যাবে
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1a56b6), // আপনার ব্র্যান্ডের নীল রঙ
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
