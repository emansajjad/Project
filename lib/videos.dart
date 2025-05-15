import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'Video_player.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class VideoItem {
  final VideoPlayerController controller;
  final String title;

  VideoItem({required this.controller, required this.title});
}

class _VideosScreenState extends State<VideosScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<VideoItem> _videoItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final result = await _storage.ref('Videos').listAll();
      for (var item in result.items) {
        if (item.name.endsWith('.mp4')) {
          final url = await item.getDownloadURL();
          final title = _formatTitle(item.name);
          final controller = VideoPlayerController.network(url);
          await controller.initialize();
          controller.setVolume(0); // mute thumbnail preview
          _videoItems.add(VideoItem(controller: controller, title: title));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error loading videos: $e')),
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  String _formatTitle(String fileName) {
    final nameWithoutExtension = fileName.replaceAll('.mp4', '');
    return nameWithoutExtension
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  void dispose() {
    for (var item in _videoItems) {
      item.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _videoItems.isEmpty
          ? const Center(child: Text('No videos found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _videoItems.length,
        itemBuilder: (context, index) {
          final item = _videoItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPlayerScreen(videoUrl: item.controller.dataSource),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                    child: Container(
                      width: 120,
                      height: 80,
                      color: Colors.black12,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: item.controller.value.size.width,
                          height: item.controller.value.size.height,
                          child: VideoPlayer(item.controller),
                        ),
                      ),
                    ),
                  ),

                  // Title
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.play_circle_fill, color: Colors.redAccent, size: 30),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
