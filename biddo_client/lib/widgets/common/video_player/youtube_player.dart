import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../theme/extensions/base.dart';

class YouTubeVideoWidget extends StatefulWidget {
  final String youtubeUrl;

  const YouTubeVideoWidget({super.key, required this.youtubeUrl});

  @override
  // ignore: library_private_types_in_public_api
  _YouTubeVideoWidgetState createState() => _YouTubeVideoWidgetState();
}

class _YouTubeVideoWidgetState extends State<YouTubeVideoWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    if (videoId == null) {
      throw 'Invalid YouTube URL provided';
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor:
          Theme.of(context).extension<CustomThemeFields>()!.action,
      progressColors: ProgressBarColors(
        playedColor: Theme.of(context).extension<CustomThemeFields>()!.action,
        handleColor: Theme.of(context).extension<CustomThemeFields>()!.action,
      ),
      onReady: () => debugPrint('YouTube Player is ready.'),
    );
  }
}
