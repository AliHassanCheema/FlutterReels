import 'package:flutter/material.dart';

import 'reel_page/reel_page_vu.dart';
import 'service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ReelService().getVideosFromApI();

    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: GetReelsWidget());
  }
}

class GetReelsWidget extends StatefulWidget {
  const GetReelsWidget({super.key});

  @override
  State<GetReelsWidget> createState() => _GetReelsWidgetState();
}

class _GetReelsWidgetState extends State<GetReelsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reels')),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              onGetreels();
            },
            child: const Text('Get Reels')),
      ),
    );
  }

  onGetreels() async {
    final reels = await ReelService().getReels();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VideoReelPage(
        index: 0, // if you want to go to any specific index
        reels: reels,
      );
    }));
  }
}
