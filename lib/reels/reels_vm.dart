// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';

import '../utils.dart';

class ReelsVM extends BaseViewModel {
  String topic = 'led';
  TextEditingController searchController = TextEditingController();
  BuildContext context;
  bool refresh = false;
  List<ReelConfig> reelConfigs = [];
  int selectedIndex = 0;
  List<String> reels = [];
  int page = 1;

  ReelsVM(this.context) {
    onGetreels();
  }

  onGetreels() async {
    if (refresh) {
      reels.clear();
      reelConfigs.clear();
      searchController.clear();
      page = 1;
      setBusy(true);
    }

    reels = await getVideosFromApI();

    for (var reelUrl in reels) {
      ReelConfig reelConfig = reelConfigs.firstWhere(
        (element) => element.url == reelUrl,
        orElse: () => ReelConfig('', false),
      );
      if (reelConfig.url.isEmpty) {
        reelConfigs.add(ReelConfig(reelUrl, false));
      } else {
        debugPrint('Already added');
      }
    }

    if (refresh) {
      refresh = false;
    }
    setBusy(false);
  }

  Future<List<String>> getVideosFromApI() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.pexels.com/videos/search?query=$topic&size=small&per_page=20&page=$page'),
        headers: {
          'Authorization':
              'VdaQqOvvGYsJnanNW163T6npK5q6TJC8fWvmOv8Pn7oGditD4qREqg3A'
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> videos = responseData['videos'];
        final List<String> urls = videos.map<String>((video) {
          return video['video_files'][1]['link'];
        }).toList();

        reels.addAll(urls);
      } else {
        Utils.showErrorSnack(
            context, 'Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      Utils.showErrorSnack(context, 'Error fetching data: $error');
    }
    return reels;
  }
}

class ReelConfig {
  String url;
  bool isLiked;

  ReelConfig(this.url, this.isLiked);
}
