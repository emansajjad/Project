import 'package:flutter/material.dart';
import 'package:my_fyp/models/university_model.dart';
import 'package:my_fyp/services/university_service.dart';
import 'package:my_fyp/uni_detail_screen.dart';

// Main screen displaying the list of universities
class UniversityListScreen extends StatefulWidget {
  const UniversityListScreen({super.key});

  @override
  State<UniversityListScreen> createState() => _UniversityListScreenState();
}

class _UniversityListScreenState extends State<UniversityListScreen> {
  final UniversityService universityService =
      UniversityService(); // Fetches university data from the service
  List<University> universities = []; // Full list of universities
  List<University> filteredUniversities =
      []; // List after applying search filter
  String searchQuery = ""; // Stores the search query entered by the user

  @override
  void initState() {
    super.initState();
    fetchUniversities(); // Fetch the universities when the screen initializes
  }

  // Method to fetch university data asynchronously
  Future<void> fetchUniversities() async {
    List<University> fetchedUniversities =
        await universityService.fetchUniversities();
    setState(() {
      universities =
          fetchedUniversities; // Full list of universities from the service
      filteredUniversities = universities; // Initially show all universities
    });
  }

  // Method to filter universities based on the search query
  void _filterUniversities(String query) {
    setState(() {
      searchQuery = query; // Update search query
      if (query.isEmpty) {
        filteredUniversities =
            universities; // Show all universities if the query is empty
      } else {
        // Filter the university list based on the search query, matching name or campus
        filteredUniversities = universities
            .where((university) =>
                university.university
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                university.mainCampus
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Universities',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black), // App bar text styling
        ),
        centerTitle: true, // Centers the title text
        backgroundColor:
            const Color.fromARGB(255, 95, 106, 162), // App bar background color
      ),
      body: Column(
        children: [
          // Search bar for filtering universities
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged:
                  _filterUniversities, // Calls method to filter universities as user types
              decoration: InputDecoration(
                hintText:
                    'Search for universities', // Placeholder text for the search bar
                prefixIcon:
                    const Icon(Icons.search), // Search icon inside the field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Rounded corners for the search bar
                  borderSide: const BorderSide(
                    color: Color.fromARGB(
                        255, 95, 106, 162), // Blue border for search bar
                    width: 2.0, // Thick border for the search bar
                  ),
                ),
              ),
            ),
          ),
          // Expanded widget to take up the remaining space for the university list
          Expanded(
            child: ListView.builder(
              itemCount: filteredUniversities
                  .length, // Use filtered list instead of full list
              itemBuilder: (context, index) {
                final university =
                    filteredUniversities[index]; // Current university item
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0), // Padding for each card
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Color.fromARGB(
                            255, 95, 106, 162), // Blue border color for card
                        width: 2.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(
                          12.0), // Rounded corners for the card
                    ),
                    elevation: 2.0, // Shadow elevation for the card
                    child: InkWell(
                      onTap: () {
                        // Navigate to the detailed screen when the card is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UniversityDetailScreen(
                                university:
                                    university), // Pass the selected university data
                          ),
                        );
                      },
                      // Content of the card
                      child: Padding(
                        padding: const EdgeInsets.all(
                            16.0), // Padding inside the card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align text to the start
                          children: [
                            // University name in bold
                            Text(
                              university.university,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8), // Space between text
                            // Main campus name in regular style
                            Text(
                              university.mainCampus,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
