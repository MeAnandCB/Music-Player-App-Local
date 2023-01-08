// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../../provider/song_model_provider.dart';
import '../../widgets/MusicTile.dart';
import 'NowPlaying.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({Key? key}) : super(key: key);

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> allSongs = [];

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  requestPermission() async {
    if (Platform.isAndroid) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff18405A),
        leading: const Icon(
          Icons.keyboard_arrow_down,
          size: 40,
        ),
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://external-preview.redd.it/7WacbRKrjFuXz4kF-nNXGc5EPk65JlDfm8du215lEXE.png?blur=40&format=pjpg&auto=webp&s=536f17c54ad7ffa33fb07694443d2ce9a332081b"),
                fit: BoxFit.cover)),
        child: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            if (item.data == null) {
              return Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("Loading")
                  ],
                ),
              );
            }
            if (item.data!.isEmpty) {
              return const Center(child: Text("Nothing found!"));
            }
            return Stack(
              children: [
                ListView.builder(
                  itemCount: item.data!.length,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                  itemBuilder: (context, index) {
                    allSongs.addAll(item.data!);
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<SongModelProvider>()
                            .setId(item.data![index].id);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NowPlaying(
                                    songModelList: [item.data![index]],
                                    audioPlayer: _audioPlayer)));
                      },
                      child: MusicTile(
                        songModel: item.data![index],
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NowPlaying(
                              songModelList: allSongs,
                              audioPlayer: _audioPlayer),
                        ),
                      );
                    },
                    child: Container(
                      height: 70,
                      color: Colors.white,
                      child: ListTile(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
