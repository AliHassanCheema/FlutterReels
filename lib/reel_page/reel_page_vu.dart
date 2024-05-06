// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'reel_video_player.dart';

class VideoReelPage extends StatefulWidget {
  const VideoReelPage(
      {super.key,
      required this.index,
      required this.reels,
      required this.reelActions});
  final Map<String, int> index;
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
    _pageController = PageController(initialPage: widget.index['index']!);
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
          widget.index['index'] = index;
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
}
