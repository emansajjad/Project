import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For file handling
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:my_fyp/Course_content/Courses_pdf.dart';

import 'package:my_fyp/QueryCenter.dart';
import 'package:my_fyp/profile.dart';
import 'package:my_fyp/signInScreen.dart';
import 'package:my_fyp/top.dart';
import 'package:my_fyp/uni_list_screen.dart'; // For working with files

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _imgfile; // This will store the picked image file
  final TextEditingController _replyController = TextEditingController(); // Controller for reply input

  // Function to pick an image from camera or gallery
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imgfile = File(pickedFile.path);
      });
    }
  }

  // Method to navigate to different screens based on button title
  void navigateToScreen(String title) {
    if (title == 'Explore') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UniversityListScreen(), // Navigate to the Universities list screen
        ),
      );
    } else if (title == 'Entry Test') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Top(), // Navigate to Test Preparation screen
        ),
      );
    } else if (title == 'Alumini Support') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QueryPage(), // Navigate to Discussion Home
        ),
      );
    }
    else if (title == 'Course Realme') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HecScreen(), // Navigate to Discussion Home
        ),
      );
    }
    // Add more navigation conditions here in the future if needed
  }

  // Method to create cards dynamically
  Widget myCards(String title, String subtitle, String buttonText) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width * 0.4, // Set width to 40% of screen width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    navigateToScreen(title); // Call the navigation method
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent.shade200,
                    backgroundColor: Colors.white, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(30), // Rounded corners
                    ),
                    side: const BorderSide(
                        color: Colors.white, width: 2), // White border
                  ),
                  child: Text(buttonText), // Button text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fetching comments along with their replies
  Future<List<Map<String, dynamic>>> getCommentsWithReplies() async {
    List<Map<String, dynamic>> commentsData = [];

    try {
      QuerySnapshot commentSnapshot = await FirebaseFirestore.instance.collection('comments').get();

      for (var commentDoc in commentSnapshot.docs) {
        Map<String, dynamic> commentData = commentDoc.data() as Map<String, dynamic>;

        // Add the document id to the comment data
        commentData['id'] = commentDoc.id;

        // Fetch replies from the sub-collection
        QuerySnapshot replySnapshot = await commentDoc.reference.collection('replies').get();

        List<Map<String, dynamic>> replies = replySnapshot.docs
            .map((replyDoc) => replyDoc.data() as Map<String, dynamic>)
            .toList();

        // Add replies to the comment data
        commentData['replies'] = replies;

        commentsData.add(commentData);
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }

    return commentsData;
  }

  // Posting a reply to a comment
  void postReply(String commentId) async {
    if (_replyController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('comments').doc(commentId).collection('replies').add({
        'replyText': _replyController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _replyController.clear(); // Clear the input field after posting the reply
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // Save height

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Custom background color
        leading:  GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Upload Image"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text("Take Image"),
                      onTap: () {
                        pickImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text("Upload from Gallery"),
                      onTap: () {
                        pickImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: _imgfile != null
                  ? FileImage(_imgfile!) // Use null check to safely access the image
                  : const AssetImage("assets/images/avatar.jpg")
              as ImageProvider, // Default image if null
            ),
          ),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.logout, color: Colors.white),
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              } else if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                ); // Logout logic here
              }
            },
            itemBuilder: (context) => [

              const PopupMenuItem(value: 2, child: Text("Logout")),
            ],
          ),

        ],
      ),
      backgroundColor:Colors.blue, // Body color

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Looking for Uni?',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Wants to secure admission in university.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),


              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myCards(
                      'Explore',
                      "List of all universities with admission details.",
                      "Open",
                    ),
                    myCards(
                        'Entry Test',
                        "Prepare yourself before appearing to entry test.",
                        "Enroll"),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myCards('Course Realme',
                        "All courses outlines according to HEC official listing approved ", "Explore"),
                    myCards("Alumini Support",
                        "Higher education tips and career counseling for student", "Learn"),
                  ],
                ),
              ),
              const SizedBox(height: 15),

            ],
          ),
        ),
      ),
    );
  }
}
