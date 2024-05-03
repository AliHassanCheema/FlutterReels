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
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reels')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: controller,
                decoration: const InputDecoration(hintText: 'Page no.'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    onGetreels();
                  },
                  child: const Text('Get Reels')),
            ],
          ),
        ),
      ),
    );
  }

  onGetreels() async {
    final reels = await ReelService()
        .getReels(controller.text == '' ? 8 : int.parse(controller.text));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VideoReelPage(
        index: 0, // if you want to go to any specific index
        reels: reels,
      );
    }));
  }
}
