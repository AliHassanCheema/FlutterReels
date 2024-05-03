import 'package:flutter/material.dart';

import 'reel_video_player.dart';

class VideoReelPage extends StatefulWidget {
  const VideoReelPage({super.key, required this.reels, required this.index});
  final List<String> reels;

  final int index;

  @override
  VideoReelPageState createState() => VideoReelPageState();
}

class VideoReelPageState extends State<VideoReelPage> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
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
          currentPage = index;
        },
        itemBuilder: (context, index) {
          return VideoPlayerWidget(
            key: Key(widget.reels[index]),
            reelUrl: widget.reels[index],
            reelActions: [
              GestureDetector(
                onTap: () {
                  debugPrint('>>>>>>>>>>>>>>>>>>>>>>>> $index tapped');
                },
                child: const Icon(
                  Icons.ac_unit_sharp,
                  color: Colors.green,
                  size: 36,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Icon(
                Icons.ac_unit_sharp,
                color: Colors.green,
                size: 36,
              ),
              const SizedBox(
                height: 20,
              ),
              const Icon(
                Icons.ac_unit_sharp,
                color: Colors.green,
                size: 36,
              )
            ],
          );
        },
      ),
    );
  }
}
