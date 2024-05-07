// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../config.dart';
import 'reel_video_player.dart';

class VideoReelPage extends StatefulWidget {
  const VideoReelPage(
      {super.key,
      required this.onGetIndex,
      required this.reels,
      required this.reelActions});
  final Function(int i) onGetIndex;
  final List<String> reels;
  final List<Widget> reelActions;

  @override
  VideoReelPageState createState() => VideoReelPageState();
}

class VideoReelPageState extends State<VideoReelPage> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    onGetReels();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: widget.reels.length,
        onPageChanged: (index) {
          widget.onGetIndex(index);
          currentPage = index;
        },
        itemBuilder: (context, index) {
          return VideoPlayerWidget(
              key: Key(widget.reels[index]),
              reelUrl: widget.reels[index],
              reelActions: widget.reelActions);
        },
      ),
    );
  }

  cacheVideos(String url, int i) async {
    FileInfo? fileInfo = await kCacheManager.getFileFromCache(url);
    if (fileInfo == null) {
      debugPrint('downloading file ##-------> $url ##');
      await kCacheManager.downloadFile(url);
      debugPrint('downloaded file ##-------> $url ##');
      if (i + 1 == widget.reels.length) {
        debugPrint('caching finished');
      }
    }
  }

  onGetReels() {
    for (var i = 0; i < widget.reels.length; i++) {
      cacheVideos(widget.reels[i], i);
    }
  }
}
