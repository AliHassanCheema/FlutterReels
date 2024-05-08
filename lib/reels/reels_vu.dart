import 'package:flutter/material.dart';
import 'package:reels_component/extensions.dart';
import 'package:stacked/stacked.dart';

import '../reel_page/reel_page_vu.dart';
import '../utils.dart';
import 'reels_vm.dart';

class ReelsVU extends StackedView<ReelsVM> {
  const ReelsVU({super.key});

  @override
  Widget builder(BuildContext context, ReelsVM viewModel, Widget? child) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(children: [
            Padding(
              padding: 12.padAll,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewModel.searchController,
                      decoration: InputDecoration(
                          hintText: 'Search...',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (viewModel.searchController.text.isNotEmpty) {
                          viewModel.refresh = true;
                          viewModel.topic = viewModel.searchController.text;
                          viewModel.onGetreels();
                        }
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 32,
                      ))
                ],
              ),
            ),
            viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : viewModel.reelConfigs.isEmpty
                    ? NoRecord(
                        icon: const Icon(
                          Icons.hourglass_empty_outlined,
                          color: Colors.white,
                        ),
                        onRefresh: () {
                          viewModel.refresh = true;
                          return viewModel.onGetreels();
                        },
                      )
                    : Expanded(
                        child: ReelPageView(
                          onRefresh: () {
                            viewModel.refresh = true;
                            return viewModel.onGetreels();
                          },
                          onGetIndex: (i) {
                            viewModel.selectedIndex = i;
                            if (i == viewModel.reels.length - 9) {
                              viewModel.page += 1;
                              viewModel.onGetreels();
                            } else {
                              viewModel.notifyListeners();
                            }
                          },
                          reels:
                              viewModel.reelConfigs.map((e) => e.url).toList(),
                          reelActions: [
                            iconButton(
                              Icons.thumb_up,
                              color: viewModel
                                      .reelConfigs[viewModel.selectedIndex]
                                      .isLiked
                                  ? Colors.blue
                                  : Colors.white,
                              onTap: () {
                                viewModel.reelConfigs[viewModel.selectedIndex]
                                        .isLiked =
                                    !viewModel
                                        .reelConfigs[viewModel.selectedIndex]
                                        .isLiked;
                                viewModel.notifyListeners();
                              },
                            ),
                            28.spaceY,
                            iconButton(
                              Icons.comment,
                              onTap: () {
                                Utils.showSnack(context,
                                    'Commented on ${viewModel.selectedIndex} - ${viewModel.reelConfigs[viewModel.selectedIndex].url}');
                              },
                            ),
                            28.spaceY,
                            iconButton(
                              Icons.share,
                              onTap: () {
                                Utils.showSnack(context,
                                    ' ${viewModel.selectedIndex} - ${viewModel.reelConfigs[viewModel.selectedIndex].url} Shared');
                              },
                            ),
                          ],
                        ),
                      )
          ])),
    );
  }

  @override
  ReelsVM viewModelBuilder(BuildContext context) {
    return ReelsVM(context);
  }

  Widget iconButton(IconData icon, {void Function()? onTap, Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: color ?? Colors.white,
        size: 36,
      ),
    );
  }
}

  // Widget inputWidget(ReelsVM viewModel) {
  //   return Center(
  //     child: Padding(
  //       padding: 40.padAll,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           CHITextField(
  //             keyboardType: TextInputType.phone,
  //             controller: viewModel.controller,
  //             hintText: 'Page no.',
  //             fillColor: Colors.white,
  //           ),
  //           20.spaceY,
  //           CHIButton(
  //               loading: viewModel.isBusy,
  //               onTap: () {
  //                 FocusManager.instance.primaryFocus?.unfocus();
  //                 viewModel.onGetreels();
  //               },
  //               label: 'Show Reels'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

 
