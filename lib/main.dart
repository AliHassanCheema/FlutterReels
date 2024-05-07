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
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  bool isBusy = false;
  bool isLiked = false;
  bool isReelsLoaded = false;
  List<ReelConfig> reelConfigs = [];
  List<String> reels = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isReelsLoaded
            ? VideoReelPage(
                onGetIndex: (i) {
                  setState(() {
                    selectedIndex = i;
                  });
                },
                reels: reelConfigs.map((e) => e.url).toList(),
                reelActions: [
                  GestureDetector(
                      onTap: () {
                        debugPrint(
                            '===============================$selectedIndex Tapped');
                        reelConfigs[selectedIndex].isLiked =
                            !reelConfigs[selectedIndex].isLiked;
                        setState(() {});
                      },
                      child: Icon(
                        Icons.thumb_up,
                        color: reelConfigs[selectedIndex].isLiked
                            ? Colors.blue
                            : Colors.white,
                        size: 36,
                      )),
                  const SizedBox(
                    height: 28,
                  ),
                  const Icon(
                    Icons.comment,
                    color: Colors.white,
                    size: 36,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  GestureDetector(
                    onTap: () {
                      isReelsLoaded = false;
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.change_circle_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: searchController,
                        decoration:
                            const InputDecoration(hintText: 'Write a topic'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                            FocusManager.instance.primaryFocus?.unfocus();
                            onGetreels();
                          },
                          child: isBusy
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  ))
                              : const Text('Get Reels')),
                    ],
                  ),
                ),
              ));
  }

  onGetreels() async {
    reelConfigs.clear();
    setState(() {
      isBusy = true;
    });
    reels = await ReelService().getReels(
        controller.text == '' ? 8 : int.parse(controller.text),
        searchController.text);
    for (int i = 0; i < reels.length; i++) {
      reelConfigs.add(ReelConfig(reels[i], false));
    }

    if (reels.isNotEmpty) {
      setState(() {
        isReelsLoaded = true;
        isBusy = false;
      });
    }
  }
}

class ReelConfig {
  String url;
  bool isLiked;

  ReelConfig(this.url, this.isLiked);
}
