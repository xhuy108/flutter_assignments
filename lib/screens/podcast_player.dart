import 'package:bai3/cubit/favorite_episode_cubit.dart';
import 'package:bai3/models/podcast_episode.dart';
import 'package:bai3/widgets/custom_bottom_navigation_bar.dart';
import 'package:bai3/widgets/podcast_episode_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';

import '../data/podcast_episodes_data.dart';

String formatDuration(Duration duration) {
  String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class PodcastPlayerScreen extends StatefulWidget {
  const PodcastPlayerScreen({
    super.key,
    required this.podcastEpisode,
  });

  final PodcastEpisode podcastEpisode;

  @override
  State<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  int selectedTab = 0;
  late List<PodcastEpisode> favoritePodcastEpisodes;
  final _audioPlayer = AudioPlayer();

  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    favoritePodcastEpisodes = podcastEpisodes
        .where((episode) => episode.title != widget.podcastEpisode.title)
        .toList();

    _audioPlayer.onPositionChanged.listen((Duration duration) {
      setState(() {
        _currentPosition = duration;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.play(
      AssetSource('audios/KhongTheSay-HIEUTHUHAI-9293024.mp3'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLiked = context.watch<FavoriteEpisodeCubit>().state.contains(
          widget.podcastEpisode,
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 24,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            splashRadius: 24,
            icon: SvgPicture.asset(
              'assets/icons/setting.svg',
            ),
          ),
          IconButton(
            onPressed: () {},
            splashRadius: 24,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedTab: selectedTab,
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 64,
                right: 64,
                top: 24,
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(widget.podcastEpisode.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        context
                            .read<FavoriteEpisodeCubit>()
                            .favoritePodcastHandler(widget.podcastEpisode);
                      },
                      icon: isLiked
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            )
                          : SvgPicture.asset('assets/icons/heart.svg'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              widget.podcastEpisode.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/shuffle.svg',
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/skip-back.svg',
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      isPlaying
                          ? await _audioPlayer.pause()
                          : await _audioPlayer.resume();
                      isPlaying = !isPlaying;
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/play.svg',
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/skip-forward.svg',
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/sync.svg',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SliderTheme(
                data: SliderThemeData(
                  overlayShape: SliderComponentShape.noThumb,
                ),
                child: Slider(
                  value: _currentPosition.inSeconds.toDouble(),
                  min: 0.0,
                  max: _duration.inSeconds.toDouble(),
                  activeColor: const Color(0xFFFF3D71),
                  inactiveColor: Colors.white.withOpacity(0.3),
                  onChanged: (value) {
                    setState(() {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    formatDuration(_currentPosition),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formatDuration(_duration),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Text(
                    'Favorite Podcast Episodes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'View all',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: favoritePodcastEpisodes.length,
              itemBuilder: (ctx, index) => PodcastEpisodeItem(
                podcastEpisode: favoritePodcastEpisodes[index],
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PodcastPlayerScreen(
                        podcastEpisode: podcastEpisodes[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
