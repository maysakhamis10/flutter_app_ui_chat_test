import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_ui_chat/Utils/AppColors.dart';
import 'package:flutter_app_ui_chat/Utils/Dimens.dart';
import 'package:flutter_app_ui_chat/Utils/Images.dart';
import 'package:flutter_app_ui_chat/Utils/Styles.dart';


class MessagesCustomAudio extends StatefulWidget {
  final String url, time;

  MessagesCustomAudio({@required this.url, this.time});

  @override
  createState() => MessagesCustomAudioState();
}

class MessagesCustomAudioState extends State<MessagesCustomAudio> {
  AudioPlayer audioPlayer;

  bool _isPlaying;
  Duration duration, position;

  @override
  initState() {
    super.initState();
    duration = position = new Duration(seconds: 0);
    audioPlayer = AudioPlayer();
    _isPlaying = false;
  }

  @override
  Widget build(BuildContext context) {
    audioPlayer.onPlayerCompletion
        .listen((_) => setState(() => _isPlaying = false));
    audioPlayer.onPlayerError.listen((msg) {
      setState(() {
        _isPlaying = false;
        duration = position = new Duration(seconds: 0);
      });
    });
    audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    audioPlayer.onDurationChanged.listen((p) => setState(() => duration = p));
    return Column(
      children: [
        Container(
            constraints: BoxConstraints(
              minWidth: DIMEN_200,
              maxWidth: DIMEN_230,
            ),
            margin: EdgeInsets.all(DIMEN_10),
            decoration: BoxDecoration(
                color: BLUE_WHITE,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: !_isPlaying
                          ? Image.asset(
                              PLAY_AUDIO_MESSAGE,
                              color: WHITE,
                            )
                          : Icon(
                              Icons.pause,
                              color: WHITE,
                            ),
                      onPressed: () {
                        !_isPlaying && position.inMilliseconds == 0
                            ? audioPlayer
                                .play(
                                  widget.url,
                                )
                                .then((i) => setState(() {
                                      _isPlaying = i == 1;
                                    }))
                            : _isPlaying
                                ? audioPlayer.pause().then((i) {
                                    _isPlaying = i != 1;
                                    setState(() {});
                                  })
                                : audioPlayer.resume().then((i) {
                                    _isPlaying = i == 1;
                                    setState(() {});
                                  });
                      }),
                  Slider(
                      activeColor: WHITE,
                      inactiveColor: WHITE,
                      value: position?.inMilliseconds?.toDouble() ?? 0.0,
                      onChanged: (double value) {
                        return audioPlayer
                            .seek(Duration(milliseconds: value.floor()));
                      },
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble()),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            padding: EdgeInsets.all(0.0),
                            iconSize: 0.0,
                            enableFeedback: false,
                            icon: Image.asset(
                              HEADPHONE_AUDIO_MESSAGE,
                              color: WHITE,
                              height: 20,
                              fit: BoxFit.fitHeight,
                            ),
                            onPressed: () {
                            }),
                        Text(
                          "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}",
                          style: WHITE_HEAVY_SMALL,
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: DARK_YELLOW_AUDIO_MESSAGE_BG_COLOR,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(DIMEN_8),
                            topLeft: Radius.circular(DIMEN_8),
                            bottomRight: Radius.circular(DIMEN_8))),
                  ),
                ],
              ),
            )),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: DIMEN_2,
          ),
          child: messageTime(),
        ),
      ],
    );
  }

  Text messageTime() {
    return Text(widget.time ?? "Time", style: TIME_STYLE);
  }

  @override
  dispose() {
    super.dispose();
    audioPlayer.release();
  }
}
