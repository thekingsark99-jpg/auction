import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../theme/extensions/base.dart';
import '../simple_button.dart';

class GenericVideoWidget extends StatefulWidget {
  final String videoUrl;

  const GenericVideoWidget({super.key, required this.videoUrl});

  @override
  // ignore: library_private_types_in_public_api
  _GenericVideoWidgetState createState() => _GenericVideoWidgetState();
}

class _GenericVideoWidgetState extends State<GenericVideoWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlaying() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor:
                      Theme.of(context).extension<CustomThemeFields>()!.action,
                  bufferedColor: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .separator,
                  backgroundColor: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .background_2,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleButton(
                    width: 150,
                    onPressed: () {
                      _togglePlaying();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _isPlaying ? "generic.stop" : "generic.start",
                          style: Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .smaller,
                        ).tr(),
                        Container(
                          width: 8,
                        ),
                        Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .fontColor_2,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color:
                  Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
            ),
          );
        }
      },
    );
  }
}
