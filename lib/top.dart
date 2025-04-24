import 'package:flutter/material.dart';
import 'package:my_fyp/books.dart';
import 'package:my_fyp/quiz.dart';
import 'package:my_fyp/quizfile.dart';
import 'package:my_fyp/videoplayer.dart';
import 'package:my_fyp/videos.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Top extends StatefulWidget {
  const Top({super.key});

  @override
  State<Top> createState() => _TopState();
}

class _TopState extends State<Top> {
  final String videoUrl = "https://youtu.be/y3iHTiPnASY?si=8Xmm-Tl6fMUubwkJ";
  late String videoId;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width using MediaQuery for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 95, 106, 162), // Set background color
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Test Preparation",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        centerTitle: true,
        backgroundColor:
            const Color.fromARGB(255, 95, 106, 162), // Replace AppBar color
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      const TabBar(
                        indicatorColor: Color.fromARGB(
                            255, 95, 106, 162), // Updated indicator color
                        labelColor: Color.fromARGB(
                            255, 95, 106, 162), // Updated label color
                        unselectedLabelColor: Colors.grey,
                        labelStyle: TextStyle(fontSize: 12),
                        tabs: [
                          Tab(text: 'Top'),
                          Tab(text: 'Videos'),
                          Tab(text: 'Quiz'),
                          Tab(text: 'Books'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Featured Videos",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 95, 106, 162),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoPlayers(
                                            videoUrl: videoUrl,
                                            description:
                                                "This is a featured video.",
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://img.youtube.com/vi/$videoId/0.jpg',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Best Books",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 95, 106, 162),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: screenWidth > 600
                                        ? 3
                                        : 2, // Responsive columns
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    padding: const EdgeInsets.all(8.0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      _buildBookItem(context, "Book 1"),
                                      _buildBookItem(context, "Book 2"),
                                      _buildBookItem(context, "Book 3"),
                                      _buildBookItem(context, "Book 4"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Videos(),
                            const Quiz(),
                            const Books(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build book item
  Widget _buildBookItem(BuildContext context, String bookName) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Quizfile())),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 95, 106, 162), // Updated book tile color
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            bookName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
