import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io';
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
  File? _imgfile;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imgfile = File(pickedFile.path);
      });
    }
  }

  // Add navigation method to handle the navigation for buttons
  void navigateToScreen(String title) {
    if (title == 'Universities') {
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
    }
    // Add more navigation conditions here in the future if needed
  }

  Widget myCards(String title, String subtitle, String buttonText) {
    // Use MediaQuery to determine the screen width
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width * 0.4, // Set width to 40% of screen width
        decoration: BoxDecoration(
          color: Colors.blueAccent.shade100,
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
                  style: const TextStyle(color: Colors.white, fontSize: 16),
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

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to adjust layout dynamically
    // ignore: unused_local_variable
    final height = MediaQuery.of(context).size.height; // Save height

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 95, 106, 162), // Custom background color
        leading: PopupMenuButton<int>(
          icon: const Icon(Icons.menu, color: Colors.black),
          onSelected: (value) {
            if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            } else if (value == 2) {
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  )); // Logout logic here
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 1, child: Text("Goto Profile")),
            const PopupMenuItem(value: 2, child: Text("Logout")),
          ],
        ),
        actions: [
          GestureDetector(
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
                    ? FileImage(_imgfile!)
                    : const AssetImage("assets/images/avatar.jpg"),
              ),
            ),
          ),
        ],
      ),
      backgroundColor:
          const Color.fromARGB(255, 95, 106, 162), // Set body color

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Hey Eman',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Wants to secure admission in university.",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search for anything",
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myCards(
                      'Universities',
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
                        "All courses outlines according to HEC.", "Explore"),
                    myCards("Career Counseling",
                        "Higher education tips and career counseling", "Learn"),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Comsats University Islamabad",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Undergraduate courses are available in Artificial Intelligence, Software Engineering, and many more.",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blueAccent.shade200,
                                backgroundColor:
                                    Colors.white, // Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Rounded corners
                                ),
                                side: const BorderSide(
                                    color: Colors.white,
                                    width: 2), // White border
                              ),
                              child: const Text("Apply Now"), // Button text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.home),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.message),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
