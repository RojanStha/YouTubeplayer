import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePagee(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePagee extends StatefulWidget {
  const MyHomePagee({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePagee> createState() => _MyHomePageeState();
}

class _MyHomePageeState extends State<MyHomePagee> {
  YoutubePlayerController? controller;
  AudioSession? audioSession;
  AudioPlayer player = AudioPlayer();

  setData() {
    controller = YoutubePlayerController(
      initialVideoId: 'eBMxIV-0rvE',
      flags: const YoutubePlayerFlags(
        loop: false,
        autoPlay: true,
        mute: false,
        isLive: true,
        hideControls: true,
        hideThumbnail: true,
        controlsVisibleAtStart: false,
        showLiveFullscreenButton: false,
      ),
    );
  }

  setupAudio() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    audioSession = session;
    await audioSession?.setActive(true);
  }

  @override
  void initState() {
    setData();
    setupAudio();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller!.play();
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          controller != null
              ? Align(
                  alignment: Alignment.topCenter,
                  child: YoutubePlayer(
                    controller: controller ??
                        YoutubePlayerController(initialVideoId: ''),
                    aspectRatio: 1,
                  ),
                )
              : const SizedBox(),
          Container(
            color: Colors.green,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Activate the audio session before playing audio.
                    await player.setAsset('assets/sound.mp3');
                    await player.play();

                    // if (player.processingState == ProcessingState.completed) {
                    //   controller!.play();
                    // }
                  },
                  child: const Text('Correct Answer'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await player.setAsset('assets/sound.mp3');
                    await player.play();
                  },
                  child: const Text('Wrong Answer'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await player.setAsset('assets/sound.mp3');
                    await player.play();
                  },
                  child: const Text('Tick Tick'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
