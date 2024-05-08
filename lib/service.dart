import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReelService {
  List<String> reels = [];

  Future<List<String>> getVideosFromApI(int page, String topic) async {
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
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching data: $error');
    }
    return reels;
  }

  Future<List<String>> getReels(int page, String topic) async {
    // reels.addAll([
    //   'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
    //   'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39765-large.mp4',
    //   'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
    //   "https://videos.pexels.com/video-files/1526909/1526909-hd_1920_1080_24fps.mp4"
    // ]);
    await getVideosFromApI(page, topic);
    return reels;
  }
}
