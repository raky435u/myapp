import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late YoutubePlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    const videoId = '4yfV5yxWBVUOsrYe'; // Replace with your YouTube video ID

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_controller.value.isPlaying && !_isPlaying) {
      setState(() {
        _isPlaying = true;
      });
    } else if (!_controller.value.isPlaying && _isPlaying) {
      setState(() {
        _isPlaying = false;
      });
      // Navigate to the next screen after video finishes (optional)
      // Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
          ),
          builder: (context, player) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                player,
                SizedBox(height: 20), // Add some spacing
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the next screen (location access or login/signup)
                    // Replace '/next_screen' with the actual route name
                    Navigator.pushReplacementNamed(context, '/next_screen');
                  },
                  child: Text('Get Started'),
                ),
                // You can add other splash screen elements here (logo, text, etc.)
              ],
            );
          },
        ),
      ),
    );
  }
}