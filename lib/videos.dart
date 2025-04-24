import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'VideoPlayer.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final Map<String, List<Map<String, String>>> videoLinks = {
    "ECAT": [
      {
        "url": "https://www.youtube.com/watch?v=cBbXbRpP84Q",
        "title": "ECAT Chemistry - Lecture 2"
      },
      {
        "url": "https://www.youtube.com/watch?v=gV1G2zLwFUo",
        "title": "ECAT Maths - Lecture 3"
      },
      {
        "url": "https://www.youtube.com/watch?v=VqoPBg21E-I",
        "title": "ECAT English - Lecture 4"
      },
    ],
    "MDCAT": [
      {
        "url": "https://youtu.be/L7LGaLZoOu0?si=cm9urF8xM_xI5G9L",
        "title": "ECAT Physics - Lecture 1"
      },
      {
        "url": "https://youtu.be/7H_bXAlyMJI?si=3cpn74zLchpGvl05",
        "title": "ECAT Chemistry - Lecture 2"
      },
      {
        "url": "https://youtu.be/ZNzA5K_7NOM?si=_ZKrcGVSBsSEzx6S",
        "title": "ECAT Maths - Lecture 3"
      },
      {
        "url": "https://youtu.be/NNp550FBRDk?si=Zdp8qDtoJi3EQaQ-",
        "title": "ECAT English - Lecture 4"
      },
    ],
    // Additional categories omitted for brevity
  };

  String getThumbnailUrl(String videoUrl) {
    try {
      Uri uri = Uri.parse(videoUrl);
      if (uri.queryParameters.containsKey('v')) {
        final videoId = uri.queryParameters['v'];
        return 'https://img.youtube.com/vi/$videoId/0.jpg';
      } else if (uri.pathSegments.isNotEmpty) {
        final videoId = uri.pathSegments.last;
        return 'https://img.youtube.com/vi/$videoId/0.jpg';
      }
    } catch (e) {
      print("Error parsing video URL: $e");
    }
    return 'https://via.placeholder.com/150/000000/FFFFFF/?text=No+Thumbnail';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap:
              true, // Ensures ListView takes only as much space as needed
          itemCount: videoLinks.keys.length,
          itemBuilder: (context, index) {
            String category = videoLinks.keys.elementAt(index);
            List<Map<String, String>> links = videoLinks[category]!;
            print("Category: $category, Number of videos: ${links.length}");

            return Card(
              color: Colors.white,
              elevation: 6,
              shadowColor: Colors.blueAccent,
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ...links.map((video) {
                      String thumbnailUrl = getThumbnailUrl(video["url"]!);
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        leading: CachedNetworkImage(
                          imageUrl: thumbnailUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          video["title"]!,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                        onTap: () {
                          final videoUrl = video["url"];
                          final description = video["title"];
                          if (videoUrl != null && description != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayers(
                                  videoUrl: videoUrl,
                                  description: description,
                                ),
                              ),
                            );
                          } else {
                            print("Error: Video URL or description is null.");
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
