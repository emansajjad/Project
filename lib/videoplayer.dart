import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class VideoPlayers extends StatefulWidget {
  final String videoUrl;
  final String description;

  const VideoPlayers({
    super.key,
    required this.videoUrl,
    required this.description,
  });

  @override
  State<VideoPlayers> createState() => _VideoPlayersState();
}

class _VideoPlayersState extends State<VideoPlayers> {
  late YoutubePlayerController _youtubePlayerController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    // Lock orientation to landscape or portrait when this screen is shown
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  Future<void> _initializePlayer() async {
    try {
      String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? "";

      if (videoId.isEmpty) {
        throw "Invalid YouTube URL";
      }

      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          loop: false,
        ),
      );

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(error.toString());
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
      ),
    );
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    // Unlock the orientation when leaving the screen
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : OrientationBuilder(
                builder: (context, orientation) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use AspectRatio to make the video adapt to the screen size
                      AspectRatio(
                        aspectRatio: orientation == Orientation.portrait
                            ? 16 / 10 // portrait aspect ratio
                            : 18 / 8, // landscape aspect ratio
                        child: YoutubePlayer(
                          controller: _youtubePlayerController,
                          showVideoProgressIndicator: true,
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
