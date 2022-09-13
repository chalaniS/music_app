import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late var isPlaying = false;
  double value = 0;

  final player = AudioPlayer();

  Duration? duration = const Duration(seconds: 0);

  Future<void> initPlayer() async {
    await player.setSource(AssetSource("music.mp3"));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/cover.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Container(
              color: Colors.black38,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                "assets/cover.jpg",
                width: 250,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Summer Vibes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.0,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //this will be modified when the music stream
                Text(
                  "${(value / 60).floor()}:${(value % 60).floor()}",
                  style: const TextStyle(color: Colors.white),
                ),

                Slider.adaptive(
                  onChanged: (v) {
                    setState(() {
                      value = v;
                    });
                  },
                  min: 0.0,
                  max: duration!.inSeconds.toDouble(),
                  value: value,
                  onChangeEnd: (newValue) async {
                    setState(() {
                      value = newValue;
                      print(newValue);
                    });
                    player.pause();
                    await player.seek(Duration(seconds: newValue.toInt()));
                    await player.resume();
                  },
                  activeColor: Colors.white,
                ),

                //this will show the total duration of the song
                Text(
                  "${duration!.inMinutes} : ${duration!.inSeconds % 60} ",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60.0),
                color: Colors.black,
                border: Border.all(color: Colors.pink),
              ),
              child: InkWell(
                onTap: () async {
                  if (isPlaying) {
                    await player.pause();

                    setState(() {
                      isPlaying = false;
                    });
                  } else {
                    await player.resume();
                    setState(() {
                      isPlaying = true;
                    });

                    player.onPositionChanged.listen((position) {
                      setState(() {
                        value = position.inSeconds.toDouble();
                      });
                    });
                  }
                },
                child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
