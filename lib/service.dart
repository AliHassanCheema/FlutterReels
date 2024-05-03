import 'dart:convert';

import 'package:http/http.dart' as http;

class ReelService {
  List<String> _reels = [];

  Future<List<String>> getVideosFromApI() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/videos/popular?per_page=40'),
        headers: {
          'Authorization':
              'VdaQqOvvGYsJnanNW163T6npK5q6TJC8fWvmOv8Pn7oGditD4qREqg3A'
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> videos = responseData['videos'];
        final List<String> urls = videos.map<String>((video) {
          return video['video_files'][1]
              ['link']; // Assuming you want the first video file link
        }).toList();

        _reels = urls;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    for (var i = 0; i < _reels.length; i++) {
      cacheVideos(_reels[i], i);
      // you can add multiple logic for to cache videos. Right now I'm caching all videos
    }
    return _reels;
  }

  cacheVideos(String url, int i) async {
    // FileInfo? fileInfo = await kCacheManager.getFileFromCache(url);
  }

  Future<List<String>> getReels() async {
    // _reels = [
    //   'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
    //   'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39765-large.mp4',
    //   'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
    //   // 'https://assets.mixkit.co/videos/preview/mixkit-frying-diced-bacon-in-a-skillet-43063-large.mp4',
    //   // 'https://assets.mixkit.co/videos/preview/mixkit-fresh-apples-in-a-row-on-a-natural-background-42946-large.mp4',
    //   // 'https://assets.mixkit.co/videos/preview/mixkit-rain-falling-on-the-water-of-a-lake-seen-up-18312-large.mp4',
    //   "https://videos.pexels.com/video-files/1526909/1526909-hd_1920_1080_24fps.mp4"
    // ];
    await getVideosFromApI();
    return _reels;
  }
}
