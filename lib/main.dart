// main.dart ফাইলের জন্য সম্পূর্ণ সংশোধিত এবং নির্ভুল কোড

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ফাইল আপলোডের জন্য দুটি প্যাকেজ ইমপোর্ট করা হলো
import 'package:webview_flutter_android/webview_flutter_android.dart';
// নিচের লাইনে টাইপিং ভুলটি সংশোধন করা হয়েছে
import 'package:image_picker/image_picker.dart';

// আপনার ওয়েবসাইটের নাম: Solve Sky.
const String solveSkyUrl = "https://www.solvesky.com";

void main() {
  runApp(const SolveSkyApp());
}

class SolveSkyApp extends StatelessWidget {
  const SolveSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // DEBUG ব্যানার সরানোর জন্য এই লাইনটি যোগ করা হয়েছে
      debugShowCheckedModeBanner: false,
      title: 'Solve Sky',
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

    // WebView কন্ট্রোলার তৈরি করা
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Loading progress দেখানোর জন্য
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            // এরর পরিচালনা করার জন্য
          },
        ),
      )
      ..loadRequest(Uri.parse(solveSkyUrl));

    // ফাইল আপলোড চালু করার জন্য এই অংশটি বিশেষভাবে যোগ করা হয়েছে
    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
          .setOnShowFileChooser((FileChooserParams params) async {
        final picker = ImagePicker();
        // গ্যালারি থেকে একটি মাত্র ছবি বা ভিডিও সিলেক্ট করার অপশন
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          // ব্যবহারকারী যদি কোনো ফাইল সিলেক্ট করে, তবে তার পাথ ফেরত পাঠানো হবে
          return [Uri.file(image.path).toString()];
        }
        // যদি কোনো ফাইল সিলেক্ট না করে, তবে খালি তালিকা ফেরত পাঠানো হবে
        return [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // ব্যাক বাটনের কার্যকারিতার জন্য এই PopScope যুক্ত করা হয়েছে
      canPop: false,
      onPopInvoked: (didPop) async {
        if (await controller.canGoBack()) {
          // যদি WebView-তে পেছনে যাওয়ার পেজ থাকে, তাহলে পেছনে যাবে
          await controller.goBack();
        } else {
          // যদি পেছনে যাওয়ার পেজ না থাকে, তাহলে অ্যাপ বন্ধ হবে
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Solve Sky'),
          elevation: 0,
          backgroundColor: Colors.blue,
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
