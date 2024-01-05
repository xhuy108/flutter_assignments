import 'package:bai3/data/categories_data.dart';
import 'package:bai3/data/podcast_episodes_data.dart';
import 'package:bai3/models/navigation_item.dart';
import 'package:bai3/models/podcast_episode.dart';
import 'package:bai3/screens/podcast_player.dart';

import 'package:bai3/widgets/category_item.dart';
import 'package:bai3/widgets/custom_bottom_navigation_bar.dart';
import 'package:bai3/widgets/custom_search_bar.dart';

import 'package:bai3/widgets/podcast_episode_item.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  int categoriedListHeight = 160;

  void _onItemTapped(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Welcome John Doe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/bell.svg',
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedTab: selectedTab,
        onTap: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 24.0,
        ),
        child: CustomScrollView(
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Looking for podcast channels',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 8),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              sliver: SliverToBoxAdapter(
                child: CustomSearchBar(),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          categoriedListHeight =
                              categoriedListHeight == 0 ? 160 : 0;
                        });
                      },
                      icon: Icon(
                        categoriedListHeight == 0
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_up_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const Text(
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
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              sliver: SliverToBoxAdapter(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: categoriedListHeight.toDouble(),
                  child: ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) => CategoryItem(
                      category: categories[index],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      'Best Podcast Episodes',
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
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
            SliverList.builder(
              itemCount: podcastEpisodes.length,
              itemBuilder: (ctx, index) => PodcastEpisodeItem(
                podcastEpisode: podcastEpisodes[index],
                onTap: () {
                  Navigator.push(
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
