// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../provider/song_model_provider.dart';
import 'AllSongs.dart';
import 'mainWindow.dart';
//import 'musicplayer.dart';

class NowPlaying extends StatefulWidget {
  final List<SongModel> songModelList;
  final AudioPlayer audioPlayer;

  const NowPlaying(
      {Key? key, required this.songModelList, required this.audioPlayer})
      : super(key: key);

  @override
  State<NowPlaying> createState() => NowPlayingState();
}

class NowPlayingState extends State<NowPlaying> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isPlaying = false;
  List<AudioSource> songList = [];

  int currentIndex = 0;

  void popBack() {
    Navigator.pop(context);
  }

  void seekToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  @override
  void initState() {
    super.initState();
    parseSong();
  }

  void parseSong() {
    try {
      for (var element in widget.songModelList) {
        songList.add(
          AudioSource.uri(
            Uri.parse(element.uri!),
            tag: MediaItem(
              id: element.id.toString(),
              album: element.album ?? "No Album",
              title: element.displayNameWOExt,
              artUri: Uri.parse(element.id.toString()),
            ),
          ),
        );
      }

      widget.audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: songList),
      );
      widget.audioPlayer.play();
      _isPlaying = true;

      widget.audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() {
            _duration = duration;
          });
        }
      });
      widget.audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
        });
      });
      listenToEvent();
      listenToSongIndex();
    } on Exception catch (_) {
      popBack();
    }
  }

  void listenToEvent() {
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void listenToSongIndex() {
    widget.audioPlayer.currentIndexStream.listen(
      (event) {
        setState(
          () {
            if (event != null) {
              currentIndex = event;
            }
            context
                .read<SongModelProvider>()
                .setId(widget.songModelList[currentIndex].id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllSongs(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Color(0xffdcdcdc),
                        radius: 25,
                        child: Icon(
                          Icons.keyboard_arrow_left_rounded,
                          size: 35,
                          color: Color(0xff434343),
                        ),
                      ),
                    ),
                    Text('Now playing'),
                    CircleAvatar(
                      backgroundColor: Color(0xffdcdcdc),
                      radius: 25,
                      child: Icon(
                        Icons.menu,
                        size: 20,
                        color: Color(0xff434343),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Music Player',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 70,
              ),
              SizedBox(
                height: 300,
                width: 300,
                child: Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 115,
                        backgroundImage: NetworkImage(
                            'https://th.bing.com/th/id/R.26b4d77edba3719089bd61010708cbf6?rik=cGj9%2bmjk%2b5NKHg&riu=http%3a%2f%2fcyberbargins.net%2favatar2.jpg&ehk=wVOsFvG53JSGWsU5iysfeNG696r0nSetxIZRIYOWHa0%3d&risl=&pid=ImgRaw&r=0'),
                      ),
                    ),
                    CircularPercentIndicator(
                      circularStrokeCap: CircularStrokeCap.round,
                      radius: 150,
                      lineWidth: 10,
                      percent: _position.inSeconds / _duration.inSeconds,
                      progressColor: Color(0xff434343),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  widget.songModelList[currentIndex].displayNameWOExt,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Album Titile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                min: 0.0,
                value: _position.inSeconds.toDouble(),
                max: _duration.inSeconds.toDouble() + 1.0,
                activeColor: Color(0xff04686a),
                inactiveColor: Color.fromARGB(255, 255, 255, 255),
                thumbColor: Color.fromARGB(255, 77, 208, 206),
                onChanged: (value) {
                  setState(
                    () {
                      seekToSeconds(value.toInt());
                      value = value;
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _position.toString().split(".")[0],
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      _duration.toString().split(".")[0],
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Color(0xffe7e7e9),
                ),
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Icon(
                      Icons.dnd_forwardslash_rounded,
                      size: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.audioPlayer.seekToNext();
                        if (widget.audioPlayer.hasPrevious) {
                          widget.audioPlayer.seekToPrevious();
                        }
                      },
                      child: Icon(
                        Icons.skip_previous,
                        size: 55,
                      ),
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: const [
                              Color(0xff04686a),
                              Color.fromARGB(255, 77, 208, 206),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_isPlaying) {
                              widget.audioPlayer.pause();
                            } else {
                              if (_position >= _duration) {
                                seekToSeconds(0);
                              } else {
                                widget.audioPlayer.play();
                              }
                            }
                            _isPlaying = !_isPlaying;
                          });
                        },
                        child: Icon(
                            _isPlaying
                                ? Icons.motion_photos_paused
                                : Icons.play_circle_outline_outlined,
                            size: 50.0,
                            color: Colors.white),
                        // color: Theme.of(context).primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.audioPlayer.seekToNext();
                        if (widget.audioPlayer.hasPrevious) {
                          widget.audioPlayer.seekToPrevious();
                        }
                      },
                      child: Icon(
                        Icons.skip_next,
                        size: 55,
                      ),
                    ),
                    Icon(
                      Icons.favorite_border,
                      size: 30,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xff434343),
            unselectedItemColor: Color(0xff434343),
            backgroundColor: Color(0xffe7e7e9),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.repeat), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.graphic_eq_outlined), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.shuffle), label: ''),
            ]),
      ),
    );
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkHeight: 300,
      artworkWidth: 300,
      artworkFit: BoxFit.cover,
      // nullArtworkWidget: MusocplayerScreen()
    );
  }
}
