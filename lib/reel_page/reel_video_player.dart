import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../config.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String reelUrl;
  final List<Widget> reelActions;

  const VideoPlayerWidget({
    super.key,
    required this.reelUrl,
    this.reelActions = const [],
  });

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeController();
  }

  bool _videoInitialized = false;

  initializeController() async {
    var fileInfo = await kCacheManager.getFileFromCache(widget.reelUrl);
    if (fileInfo == null) {
      await kCacheManager.downloadFile(widget.reelUrl);
      fileInfo = await kCacheManager.getFileFromCache(widget.reelUrl);
    }
    if (mounted) {
      _controller = VideoPlayerController.file(fileInfo!.file)
        ..initialize().then((_) {
          setState(() {
            _controller.setLooping(true); // Set video to loop
            _controller.play();
            _videoInitialized = true;
          });
        });
      _controller.addListener(() {
        if (_controller.value.isPlaying && !_isPlaying) {
          // Video has started playing
          setState(() {
            _isPlaying = true;
          });
        }
      });
    }
  }

  bool _isPlaying = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      _controller.play();
    } else if (state == AppLifecycleState.inactive) {
      // App is partially obscured
      _controller.pause();
    } else if (state == AppLifecycleState.paused) {
      // App is in the background
      _controller.pause();
    } else if (state == AppLifecycleState.detached) {
      // App is terminated
      _controller.dispose();
    }
  }

  @override
  void dispose() {
    debugPrint('disposing a controller');
    if (mounted) {
      _controller.dispose();
    } // Dispose of the controller when done
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_videoInitialized) {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                    _isPlaying = false;
                  } else {
                    _controller.play();
                    _isPlaying = true;
                  }
                });
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                !_videoInitialized
                    // when the video is not initialized you can set a thumbnail.
                    // to make it simple, I use CircularProgressIndicator
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      )
                    : VideoPlayer(_controller),
                !_videoInitialized
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      )
                    : const SizedBox(),
                if (!_isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                !_videoInitialized
                    ? const SizedBox()
                    : VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.amber,
                          bufferedColor: Colors.grey,
                          backgroundColor: Colors.white,
                        ),
                      )
              ],
            ),
          ),
          Positioned(
              right: 16,
              bottom: 36,
              child: Column(children: widget.reelActions)),

          // here you can add title, user Info,
          // description, views count etc.
        ],
      ),
    );
  }
}
