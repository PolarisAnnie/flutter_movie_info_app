import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/detail_page.dart';
import 'package:flutter_movie_info_app/presentation/pages/home/home_view_model.dart';
import 'package:flutter_movie_info_app/presentation/pages/home/widgets/movie_list.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 홈 페이지 위젯
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // 뷰모델 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homePageViewModelProvider.notifier).loadAllMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homePageViewModelProvider);

    // 로딩 상태 및 영화 목록이 비어있을 때 로딩 인디케이터 표시
    if (state.isLoading && state.nowPlayingMovies.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 데이터가 있을 때 페이지 빌드
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            // 새로고침 시 모든 영화 데이터 다시 로드
            await ref
                .read(homePageViewModelProvider.notifier)
                .refreshAllMovies();
          },
          child: ListView(
            children: [
              Text('가장 인기있는', style: AppTheme.titleStyle),
              const SizedBox(height: 10),
              // 가장 인기 있는 영화의 포스터를 탭하여 상세 페이지로 이동
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
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${mainMovie.posterPath}',
                        ),
                      ),
                    );
                  }
                },
                child: SizedBox(
                  height: 500,
                  width: double.infinity,
                  // Hero 애니메이션 적용
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
                            // 포스터 이미지가 없으면 대체 이미지 사용
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
              const SizedBox(height: 18),
              // 현재 상영 중 영화 리스트 표시
              MovieList(
                label: '현재 상영 중',
                orderByPopular: false,
                movies: state.nowPlayingMovies,
              ),
              const SizedBox(height: 18),
              // 인기순 영화 리스트 표시
              MovieList(
                label: '인기순',
                orderByPopular: true,
                movies: state.popularMovies,
                // 스크롤 시 추가 데이터 로드
                onLoadMore: () {
                  ref
                      .read(homePageViewModelProvider.notifier)
                      .loadMorePopularMovies();
                },
                isLoadingMore: state.isLoadingMorePopular, // 추가 로딩 상태
              ),
              const SizedBox(height: 18),
              // 평점 높은 순 영화 리스트 표시
              MovieList(
                label: '평점 높은 순',
                orderByPopular: false,
                movies: state.topRatedMovies,
              ),
              const SizedBox(height: 18),
              // 개봉 예정 영화 리스트 표시
              MovieList(
                label: '개봉 예정',
                orderByPopular: false,
                movies: state.upcomingMovies,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
