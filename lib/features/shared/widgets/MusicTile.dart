import 'package:flutter/material.dart';
import 'package:flutter_music_player/utils/extensions/SongModelExtension.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicTile extends StatelessWidget {
  final SongModel songModel;

  const MusicTile({
    required this.songModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        songModel.displayNameWOExt,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 31, 30, 30)),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        songModel.additionalSongInfo,
        style: TextStyle(color: Color.fromARGB(255, 31, 31, 31)),
      ),
      trailing:
          const Icon(Icons.more_horiz, color: Color.fromARGB(255, 39, 39, 39)),
      leading: QueryArtworkWidget(
          id: songModel.id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: Image.network(
              'https://yt3.ggpht.com/a/AATXAJyhVfkA7SiCqQb34xERK9FMDiDpDETI8Prg67YM=s900-c-k-c0xffffffff-no-rj-mo')),
    );
  }
}
