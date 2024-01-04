import 'package:bai3/models/podcast_episode.dart';
import 'package:bai3/widgets/custom_navigation_bar.dart';
import 'package:bai3/widgets/podcast_episode_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/podcast_episodes_data.dart';

class PodcastPlayerScreen extends StatefulWidget {
  const PodcastPlayerScreen({super.key, required this.podcastEpisode});

  final PodcastEpisode podcastEpisode;

  @override
  State<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  late List<PodcastEpisode> favoritePodcastEpisodes;
  double listeningDuration = 0;

  @override
  void initState() {
    super.initState();
    favoritePodcastEpisodes = podcastEpisodes
        .where((episode) => episode.title != widget.podcastEpisode.title)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: const CustomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 48,
                  right: 48,
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
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/icons/heart.svg'),
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
              Row(
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
                    onPressed: () {},
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
              const SizedBox(
                height: 24,
              ),
              SliderTheme(
                data: SliderThemeData(
                  overlayShape: SliderComponentShape.noThumb,
                ),
                child: Slider(
                  value: listeningDuration,
                  activeColor: const Color(0xFFFF3D71),
                  inactiveColor: Colors.white.withOpacity(0.3),
                  onChanged: (value) {
                    setState(() {
                      listeningDuration = value;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    '00:00',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '03:05',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const Row(
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
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: favoritePodcastEpisodes.length,
                itemBuilder: (ctx, index) => PodcastEpisodeItem(
                  podcastEpisode: favoritePodcastEpisodes[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
