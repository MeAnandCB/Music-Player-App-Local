// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../../provider/song_model_provider.dart';
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
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/nowplayingbackground.jpg'),
                  fit: BoxFit.cover)),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  IconButton(
                    onPressed: () {
                      popBack();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.red,
                    ),
                  ),
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        'Hi Anand',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.green,
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/circleavatarbg.jfif'),
                          radius: 22,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  popBack();
                },
                child: Text(
                  widget.songModelList[currentIndex].displayNameWOExt,

                  // textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                      overflow: TextOverflow.ellipsis),
                  maxLines: 1,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Now Playing",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Stack(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    CircleAvatar(
                      radius: 158,
                      backgroundColor: Colors.white10,
                      child: CircleAvatar(
                        radius: 148,
                        backgroundColor: Colors.white12,
                        child: CircleAvatar(
                          radius: 134,
                          child: CircleAvatar(
                            radius: 129,
                            backgroundImage: AssetImage('assets/musicbg.webp'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircleAvatar(child: Icon(Icons.favorite)),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                      child: GestureDetector(child: Icon(Icons.more_horiz)))
                ], // music bar
              ),
              const SizedBox(
                height: 15.0,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Slider(
                min: 0.0,
                value: _position.inSeconds.toDouble(),
                max: _duration.inSeconds.toDouble() + 1.0,
                activeColor: Color.fromARGB(255, 0, 88, 183),
                inactiveColor: Color.fromARGB(255, 255, 255, 255),
                thumbColor: Color.fromARGB(255, 255, 0, 0),
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
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(.1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Icon(Icons.shuffle, size: 30.0, color: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onDoubleTap: () {
                            widget.audioPlayer.seekToNext();
                            if (widget.audioPlayer.hasPrevious) {
                              widget.audioPlayer.seekToPrevious();
                            }
                          },
                          child: Icon(Icons.skip_previous,
                              size: 50.0, color: Colors.white),
                        ),
                      ],
                    ),
                    GestureDetector(
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
                          size: 90.0,
                          color: Colors.white),
                      // color: Theme.of(context).primaryColor,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onDoubleTap: () {
                            widget.audioPlayer.seekToNext();
                          },
                          child: const Icon(Icons.skip_next,
                              size: 50.0, color: Colors.white),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.replay_outlined,
                            size: 30.0, color: Colors.white),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
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
