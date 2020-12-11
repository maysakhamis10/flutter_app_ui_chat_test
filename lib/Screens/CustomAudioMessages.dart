import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_ui_chat/Utils/AppColors.dart';
import 'package:flutter_app_ui_chat/Utils/Dimens.dart';
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
              minWidth: DIMEN_230,
              maxWidth: DIMEN_280,
            ),
            padding: EdgeInsets.all(DIMEN_5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: !_isPlaying
                          ? Icon(
                              Icons.play_arrow,
                              color: BLUE,
                        size: 40,
                            )
                          : Icon(
                              Icons.pause,
                              color: BLUE,
                        size: 40,

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
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: BLUE,
                      inactiveTrackColor: GREY,
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbColor: BLUE,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top : 10.0),
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Slider(
                        activeColor: BLUE,
                        inactiveColor:GREY,
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble(),
                        value: position?.inMilliseconds?.toDouble() ?? 0.0,
                        onChanged: (double value) {
                          return audioPlayer.seek(Duration(milliseconds: value.floor()));
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                       Container(
                         margin: EdgeInsets.only(top : 10.0),
                         child:  IconButton(
                           enableFeedback: false,
                           icon:Icon(
                             Icons.headset,
                             color: GREEN,
                             size: 40,
                           ),
                           onPressed: () {
                           }),
                       ),
                        Text(
                          "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}",
                          style: WHITE_HEAVY_SMALL,
                        )
                      ],
                    ),
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
