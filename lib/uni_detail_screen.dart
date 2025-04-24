import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_fyp/models/university_model.dart';

class UniversityDetailScreen extends StatefulWidget {
  final University university;

  const UniversityDetailScreen({super.key, required this.university});

  @override
  State<UniversityDetailScreen> createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.university.university,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 95, 106, 162),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildLabelAndContainer(
                'Main Campus:', widget.university.mainCampus),
            const SizedBox(height: 10),
            _buildLabelAndContainer('Address:', widget.university.address),
            const SizedBox(height: 10),
            _buildLabelAndContainer('Phone:', widget.university.phone),
            const SizedBox(height: 10),
            _buildLabelAndContainer('Email:', widget.university.email,
                isLink: true, isEmail: true),
            const SizedBox(height: 10),
            _buildLabelAndContainer('Website:', widget.university.url,
                isLink: true),
            const SizedBox(height: 10),
            _buildLabelAndContainer('Campuses:', widget.university.campuses),
          ],
        ),
      ),
    );
  }

  // Function to build each label and its corresponding container for the value
  Widget _buildLabelAndContainer(String label, String value,
      {bool isLink = false, bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width:
              double.infinity, // Ensures the container takes up the full width
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
                color: const Color.fromARGB(255, 95, 106, 162),
                width: 2), // Border color and width
          ),
          child: isLink
              ? GestureDetector(
                  onTap: () {
                    if (isEmail) {
                      _launchURL('mailto:$value', context); // Handle email
                    } else {
                      _launchURL(value, context); // Handle website URL
                    }
                  },
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
        ),
      ],
    );
  }

  // Function to launch URLs or emails
  void _launchURL(String url, BuildContext context) async {
    Uri uri;

    // Handle email URLs (mailto:)
    if (url.startsWith('mailto:')) {
      uri = Uri.parse(url);
    } else if (!url.startsWith('http') && !url.startsWith('https')) {
      // If the URL doesn't start with 'http' or 'https', add 'http://' by default
      uri = Uri.parse('http://$url');
    } else {
      uri = Uri.parse(url);
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open URL: $url')),
      );
    }
  }
}
