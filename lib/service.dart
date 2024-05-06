import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class ReelService {
  List<String> reels = [];

  Future<List<String>> getVideosFromApI(int page) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.pexels.com/videos/popular?per_page=20&page=$page'),
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
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    for (var i = 0; i < reels.length; i++) {
      cacheVideos(reels[i], i);
      // you can add multiple logic for to cache videos. Right now I'm caching all videos
    }
    return reels;
  }

  cacheVideos(String url, int i) async {
    // FileInfo? fileInfo = await kCacheManager.getFileFromCache(url);

    // debugPrint(
    //     '================================= File info: ${fileInfo?.file.dirname}');
    FileInfo? fileInfo = await kCacheManager.getFileFromCache(url);
    if (fileInfo == null) {
      debugPrint('downloading file ##------->$url##');
      await kCacheManager.downloadFile(url);
      debugPrint('downloaded file ##------->$url##');
      if (i + 1 == reels.length) {
        debugPrint('caching finished');
      }
    }
  }

  Future<List<String>> getReels(int page) async {
    reels.addAll([
      'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
      'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39765-large.mp4',
      'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
      "https://videos.pexels.com/video-files/1526909/1526909-hd_1920_1080_24fps.mp4"
    ]);
    await getVideosFromApI(page);
    return reels;
  }
}
