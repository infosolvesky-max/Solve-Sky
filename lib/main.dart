// main.dart ফাইলের জন্য চূড়ান্তভাবে সংশোধ
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Android-এর ফিচার ব্যবহারের জন্য এই ইমপোর্টটি জরুরি
import 'package:webview_flutter_android/webview_flutter_android.dart';

// আপনার ওয়েবসাইটের ঠিকানা
const String solveSkyUrl = "https://www.solvesky.com";

void main() {
  runApp(const SolveSkyApp());
}

class SolveSkyApp extends StatelessWidget {
  const SolveSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solve Sky',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
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
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // --- WebView কন্ট্রোলার তৈরির নতুন এবং সঠিক পদ্ধতি ---

    // 1. প্রথমে Android-এর জন্য বিশেষ প্যারামিটার তৈরি করা
    final AndroidWebViewControllerCreationParams androidParams =
        AndroidWebViewControllerCreationParams(
      // ফাইল আপলোডের অনুরোধ পরিচালনা করার জন্য এই ফাংশনটি যোগ করা হয়েছে
      onShowFileChooser: (final FileChooserParams params) async {
        final picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          // ব্যবহারকারী ফাইল সিলেক্ট করলে তার পাথ ফেরত পাঠানো হবে
          return <String>[Uri.file(image.path).toString()];
        }
        // ফাইল সিলেক্ট না করলে খালি তালিকা ফেরত পাঠানো হবে
        return <String>[];
      },
    );

    // 2. মূল কন্ট্রোলার তৈরি করার সময় উপরের প্যারামিটারটি যোগ করা
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(
      PlatformWebViewControllerCreationParams(
        android: androidParams,
      ),
    );

    // 3. কন্ট্রোলারের বাকি বৈশিষ্ট্যগুলো সেট করা
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(solveSkyUrl));
    
    // Android WebView-তে ডিবাগিং চালু করা (ঐচ্ছিক কিন্তু সহায়ক)
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // ব্যাক বাটনের কার্যকারিতার জন্য
      canPop: false,
      onPopInvoked: (final bool didPop) async {
        if (await _controller.canGoBack()) {
          await _controller.goBack();
        } else {
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Solve Sky'),
          elevation: 0,
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
