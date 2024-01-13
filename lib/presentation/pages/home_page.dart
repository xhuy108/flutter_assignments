import 'package:bai5/presentation/cubit/news_cubit.dart';
import 'package:bai5/presentation/widgets/loader.dart';
import 'package:bai5/presentation/widgets/news_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  void _onScroll() {
    if (_isBottom) {
      context.read<NewsCubit>().fetchNews(page);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll == maxScroll;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/icons/menu.svg',
            width: 30,
          ),
        ),
        title: Text(
          'My News',
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF1D1A61),
                Color(0xFF18DAB8),
              ],
            ),
          ),
        ),
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Text(
                'News',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF1D1A61),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  if (state.status == NewsStatus.loading) {
                    return const Loader();
                  }
                  if (state.status == NewsStatus.failure) {
                    return Center(
                      child: Text(state.error),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.hasReachedMax
                        ? state.news.length
                        : state.news.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.news.length) {
                        page++;
                        return const Loader();
                      } else {
                        return NewsItem(
                          news: state.news[index],
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        },
        tooltip: 'Scroll to top',
        backgroundColor: const Color.fromRGBO(29, 26, 97, 0.7),
        shape: const CircleBorder(),
        child: SvgPicture.asset(
          'assets/icons/scroll-to-top.svg',
        ),
      ),
    );
  }
}
