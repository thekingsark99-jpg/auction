import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'generic_player.dart';
import 'youtube_player.dart';

class AdaptiveVideoWidget extends StatelessWidget {
  final String videoUrl;

  const AdaptiveVideoWidget({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null) {
      return YouTubeVideoWidget(youtubeUrl: videoUrl);
    } else {
      return GenericVideoWidget(videoUrl: videoUrl);
    }
  }
}
