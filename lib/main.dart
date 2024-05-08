import 'package:flutter/material.dart';
import 'package:reels_component/reels/reels_vu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: ReelsVU());
  }
}

// class GetReelsWidget extends StatefulWidget {
//   const GetReelsWidget({super.key});

//   @override
//   State<GetReelsWidget> createState() => _GetReelsWidgetState();
// }

// class _GetReelsWidgetState extends State<GetReelsWidget> {
//   TextEditingController controller = TextEditingController();
//   TextEditingController searchController = TextEditingController();
//   int page = 1;
//   int selectedIndex = 0;
//   bool isBusy = false;
//   bool isLiked = false;
//   bool isReelsLoaded = false;
//   List<ReelConfig> reelConfigs = [];
//   List<String> reels = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: isReelsLoaded
//             ? VideoReelPage(
//                 onGetIndex: (i) {
//                   setState(() {
//                     selectedIndex = i;
//                   });
//                 },
//                 reels: reelConfigs.map((e) => e.url).toList(),
//                 reelActions: [
//                   iconButton(
//                     Icons.thumb_up,
//                     color: reelConfigs[selectedIndex].isLiked
//                         ? Colors.blue
//                         : Colors.white,
//                     onTap: () {
//                       setState(() {
//                         reelConfigs[selectedIndex].isLiked =
//                             !reelConfigs[selectedIndex].isLiked;
//                       });
//                     },
//                   ),
//                   28.spaceY,
//                   iconButton(
//                     Icons.comment,
//                     onTap: () {
//                       Utils.showSnack(context,
//                           'Commented on $selectedIndex - ${reelConfigs[selectedIndex].url}');
//                     },
//                   ),
//                   28.spaceY,
//                   iconButton(
//                     Icons.share,
//                     onTap: () {
//                       Utils.showSnack(context,
//                           ' $selectedIndex - ${reelConfigs[selectedIndex].url} Shared');
//                     },
//                   ),
//                 ],
//               )
//             : Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(40.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
                      // TextFormField(
                      //   controller: searchController,
                      //   decoration:
                      //       const InputDecoration(hintText: 'Write a topic'),
                      // ),
//                       20.spaceY,
//                       ElevatedButton(
//                           onPressed: () {
//                             FocusManager.instance.primaryFocus?.unfocus();
//                             onGetreels();
//                           },
//                           child: isBusy
//                               ? const SizedBox(
//                                   height: 16,
//                                   width: 16,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 1.5,
//                                   ))
//                               : const Text('Get Reels')),
//                     ],
//                   ),
//                 ),
//               ));
//   }

//   onGetreels() async {
//     reelConfigs.clear();
//     setState(() {
//       isBusy = true;
//     });
//     reels = await ReelService().getReels(
//         controller.text == '' ? 8 : int.parse(controller.text),
//         searchController.text);
//     for (int i = 0; i < reels.length; i++) {
//       reelConfigs.add(ReelConfig(reels[i], false));
//     }

//     if (reels.isNotEmpty) {
//       setState(() {
//         isReelsLoaded = true;
//         isBusy = false;
//       });
//     }
//   }

//   Widget iconButton(IconData icon, {void Function()? onTap, Color? color}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Icon(
//         icon,
//         color: color ?? Colors.white,
//         size: 36,
//       ),
//     );
//   }
// }

// class ReelConfig {
//   String url;
//   bool isLiked;

//   ReelConfig(this.url, this.isLiked);
// }
