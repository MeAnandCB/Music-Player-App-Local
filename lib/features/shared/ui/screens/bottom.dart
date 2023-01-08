// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'NowPlaying.dart';

class NowPlayingBottomBar extends StatefulWidget {
  const NowPlayingBottomBar({super.key});

  @override
  State<NowPlayingBottomBar> createState() => _NowPlayingBottomBarState();
}

class _NowPlayingBottomBarState extends State<NowPlayingBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Color(0xff434343),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                'https://th.bing.com/th/id/R.26b4d77edba3719089bd61010708cbf6?rik=cGj9%2bmjk%2b5NKHg&riu=http%3a%2f%2fcyberbargins.net%2favatar2.jpg&ehk=wVOsFvG53JSGWsU5iysfeNG696r0nSetxIZRIYOWHa0%3d&risl=&pid=ImgRaw&r=0'),
            backgroundColor: Colors.white,
          ),
          title: Text(
            'Song Title',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Text(
            'Album Name',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: Icon(
            Icons.play_circle_outline_rounded,
            size: 55,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
