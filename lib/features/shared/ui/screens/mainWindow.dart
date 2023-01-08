// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 500,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 28, 147, 149),
                          radius: 30,
                        ),
                        title: Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff434343),
                          ),
                        ),
                        trailing: CircleAvatar(
                            radius: 25,
                            backgroundColor: Color.fromARGB(255, 184, 184, 184),
                            child: Icon(
                              Icons.settings,
                              size: 30,
                              color: Color(0xff434343),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Playlists',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff434343),
                          ),
                        ),
                        Text(
                          'view more >',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff434343),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10, bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(255, 0, 0, 0),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://www.plumeriamovies.com/wp-content/uploads/2019/07/cropped-Jeevamshamaayi-song-lyrics-in-Malayalam-1.jpg'))),
                            height: 60,
                            width: 250,
                          ),
                        );
                      }),
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 20),
                        child: Text(
                          'Your Songs',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff434343),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // ignore: prefer_const_constructors
                  gradient: LinearGradient(colors: const [
                    Color.fromARGB(255, 8, 115, 117),
                    Color.fromARGB(255, 77, 208, 206),
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, top: 15),
                  child: ListView.separated(
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                'https://th.bing.com/th/id/OIP.WS-xyBJSePDlXOx0lGar6QAAAA?pid=ImgDet&w=450&h=450&rs=1'),
                          ),
                          title: Text(
                            'Song Title',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Album Name',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: Icon(
                            Icons.more_vert_rounded,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }
}
