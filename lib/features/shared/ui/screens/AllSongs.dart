// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../../provider/song_model_provider.dart';
import '../../widgets/MusicTile.dart';
import 'NowPlaying.dart';
import 'bottom.dart';
import 'mainWindow.dart';

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
      body: FutureBuilder<List<SongModel>>(
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
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  // ignore: prefer_const_constructors
                  gradient: LinearGradient(colors: const [
                    Color.fromARGB(255, 8, 115, 117),
                    Color.fromARGB(255, 77, 208, 206),
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                  borderRadius: BorderRadius.circular(35),
                ),
                height: 370,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainWindow(),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 28, 147, 149),
                                // ignore: sort_child_properties_last
                                child: Icon(
                                  Icons.keyboard_arrow_left,
                                  size: 35,
                                ),
                                radius: 30,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Container(
                              height: 60,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color.fromARGB(255, 28, 147, 149),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search your Music",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Color(0xff67bfc0)),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 20,
                                      color: Color(0xff67bfc0),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 77,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 72,
                              backgroundImage: NetworkImage(
                                  'https://th.bing.com/th/id/R.26b4d77edba3719089bd61010708cbf6?rik=cGj9%2bmjk%2b5NKHg&riu=http%3a%2f%2fcyberbargins.net%2favatar2.jpg&ehk=wVOsFvG53JSGWsU5iysfeNG696r0nSetxIZRIYOWHa0%3d&risl=&pid=ImgRaw&r=0'),
                              backgroundColor: Color.fromARGB(255, 8, 115, 117),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                'Singer',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Song Title',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '7 album - 50 tracks',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'All Tracks',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff434343),
                      ),
                    ),
                    Text('View More')
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: ListView.builder(
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
                          ));
                    },
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlaying(
                            songModelList: allSongs, audioPlayer: _audioPlayer),
                      ),
                    );
                  },
                  child: NowPlayingBottomBar())
            ],
          );
        },
      ),
    );
  }
}
