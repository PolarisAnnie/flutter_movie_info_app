import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/detail_page.dart';
import 'package:flutter_movie_info_app/presentation/pages/home/home_view_model.dart';
import 'package:flutter_movie_info_app/presentation/pages/home/widgets/movie_list.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // ViewModel 데이터 로딩
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homePageViewModelProvider.notifier).loadAllMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homePageViewModelProvider);

    if (state.isLoading && state.nowPlayingMovies.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
      child: Scaffold(
        body: ListView(
          children: [
            Text('가장 인기있는', style: AppTheme.titleStyle),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                final mainMovie = state.nowPlayingMovies.isNotEmpty
                    ? state.nowPlayingMovies.first
                    : null;

                if (mainMovie != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        movieId: mainMovie.id,
                        heroTag: 'movie-main-poster',
                      ),
                    ),
                  );
                }
              },
              child: SizedBox(
                height: 500,
                width: double.infinity,
                child: Hero(
                  tag: 'movie-main-poster',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Builder(
                      builder: (context) {
                        final mainMovie = state.nowPlayingMovies.isNotEmpty
                            ? state.nowPlayingMovies.first
                            : null;

                        return Image.network(
                          mainMovie?.posterPath != null
                              ? 'https://image.tmdb.org/t/p/w500${mainMovie!.posterPath}'
                              : 'https://picsum.photos/500/700',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 18),
            MovieList(
              label: '현재 상영 중',
              orderByPopular: false,
              movies: state.nowPlayingMovies,
            ),
            SizedBox(height: 18),
            MovieList(
              label: '인기순',
              orderByPopular: true,
              movies: state.popularMovies,
              onLoadMore: () {
                ref
                    .read(homePageViewModelProvider.notifier)
                    .loadMorePopularMovies();
              },
              isLoadingMore: state.isLoadingMorePopular,
            ),

            SizedBox(height: 18),
            MovieList(
              label: '평점 높은 순',
              orderByPopular: false,
              movies: state.topRatedMovies,
            ),
            SizedBox(height: 18),
            MovieList(
              label: '개봉 예정',
              orderByPopular: false,
              movies: state.upcomingMovies,
            ),
          ],
        ),
      ),
    );
  }
}
