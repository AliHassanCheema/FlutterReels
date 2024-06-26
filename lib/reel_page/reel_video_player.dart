import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class ReelVideoPlayerWidget extends StatefulWidget {
  final String reelUrl;
  final List<Widget> reelActions;

  const ReelVideoPlayerWidget({
    super.key,
    required this.reelUrl,
    this.reelActions = const [],
  });

  @override
  ReelVideoPlayerWidgetState createState() => ReelVideoPlayerWidgetState();
}

class ReelVideoPlayerWidgetState extends State<ReelVideoPlayerWidget>
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
    if (fileInfo != null) {
      // await kCacheManager.downloadFile(widget.reelUrl);
      // fileInfo = await kCacheManager.getFileFromCache(widget.reelUrl);
      if (mounted) {
        _controller = VideoPlayerController.file(fileInfo.file)
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
    } else {
      if (mounted) {
        _controller = VideoPlayerController.network(widget.reelUrl)
          ..initialize().then((_) {
            setState(() {
              _controller.setLooping(true); // Set video to loop
              _controller.play();
              _videoInitialized = true;
            });
          });
        _controller.addListener(() {
          if (_controller.value.isPlaying && !_isPlaying) {
            setState(() {
              _isPlaying = true;
            });
          }
        });
      }
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
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller)),
                      ),
                !_videoInitialized
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox(),
                if (!_isPlaying && _videoInitialized)
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
        ],
      ),
    );
  }
}

const kReelCacheKey = "reelsCacheKey";
final kCacheManager = CacheManager(
  Config(
    kReelCacheKey,
    stalePeriod: const Duration(hours: 1), // Maximum cache duration
    maxNrOfCacheObjects: 4, // maximum reels to cache
    repo: JsonCacheInfoRepository(databaseName: kReelCacheKey),
    fileService: HttpFileService(),
  ),
);
