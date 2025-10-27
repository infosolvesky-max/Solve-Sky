import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> profiles = [];
  bool isLoading = true;
  String? errorMessage; // এরর মেসেজ দেখানোর জন্য নতুন ভ্যারিয়েবল

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  Future<void> fetchProfiles() async {
    // আপনার আসল ওয়েবসাইটের লিঙ্কটি এখানে দেওয়া আছে
    final url = Uri.parse('https://solvesky.com/api/get_all_profiles.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'success') {
          setState(() {
            profiles = result['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'API Error: ${result['message']}';
            isLoading = false;
          });
        }
      } else {
        // সার্ভার থেকে কোনো এরর আসলে
        setState(() {
          errorMessage = 'Server Error: Please try again later. (Code: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      // ইন্টারনেট বা অন্য কোনো এরর হলে
      setState(() {
        errorMessage = 'An error occurred. Please check your internet connection and try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve Sky'),
        backgroundColor: const Color(0xFF1a56b6), // আপনার ওয়েবসাইটের নীল রঙ
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: buildBody(), // মূল কন্টেন্ট দেখানোর জন্য একটি আলাদা ফাংশন
    );
  }

  // এই ফাংশনটি ডেটার অবস্থার উপর নির্ভর করে ভিন্ন ভিন্ন জিনিস দেখাবে
  Widget buildBody() {
    // যদি ডেটা লোড হতে থাকে
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // যদি কোনো এরর মেসেজ থাকে
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16)
          ),
        ),
      );
    }

    // যদি কোনো প্রোফাইল না পাওয়া যায়
    if (profiles.isEmpty) {
      return const Center(child: Text('No profiles found.'));
    }

    // সবকিছু ঠিক থাকলে প্রোফাইলের তালিকা দেখানো হবে
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];
        final profilePhotoUrl = profile['profile_photo_path'];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          elevation: 4.0,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              backgroundImage: (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty)
                  ? NetworkImage(profilePhotoUrl)
                  : null,
              child: (profilePhotoUrl == null || profilePhotoUrl.isEmpty)
                  ? Text(
                profile['name']?[0] ?? 'S',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              )
                  : null,
            ),
            title: Text(
              profile['name'] ?? 'No Name',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              profile['profession'] ?? 'No Profession',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.blue),
            onTap: () {
              // ভবিষ্যতে এখানে ক্লিক করলে প্রোফাইল ডিটেইলস পেজে যাবে
            },
          ),
        );
      },
    );
  }
}