import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/domain/entity/movie.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/detail_page.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

// 영화 목록을 가로로 스크롤하여 표시
class MovieList extends StatelessWidget {
  final String label;
  final bool orderByPopular;
  final List<Movie> movies;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  const MovieList({
    required this.label,
    required this.orderByPopular,
    required this.movies,
    this.onLoadMore,
    this.isLoadingMore = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 영화 목록이 비어 있을 때 처리
    if (movies.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.titleStyle),
          const SizedBox(height: 10),
          const Text('영화 정보가 없습니다', style: TextStyle(color: Colors.grey)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.titleStyle),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          // 스크롤 이벤트 감지
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // 스크롤이 끝에 가까워질 때 추가 로드 요청
              if (orderByPopular &&
                  onLoadMore != null &&
                  !isLoadingMore &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 100) {
                onLoadMore!();
              }
              return false;
            },
            // 영화 목록 효율적 렌더링
            child: ListView.builder(
              // 인기순 목록에 로딩 중일 경우 항목 1개 추가
              itemCount:
                  movies.length + (orderByPopular && isLoadingMore ? 1 : 0),
              scrollDirection: Axis.horizontal, // 가로 스크롤
              itemBuilder: (context, index) {
                // 인기순 목록의 마지막 항목일 경우 로딩 인디케이터 표시
                if (orderByPopular && index == movies.length && isLoadingMore) {
                  return Container(
                    width: 120,
                    height: 180,
                    margin: const EdgeInsets.only(right: 12),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }

                final movie = movies[index];

                return Row(
                  children: [
                    Padding(
                      // 인기순 목록일 때 더 넓은 패딩 적용
                      padding: orderByPopular
                          ? const EdgeInsets.only(right: 24)
                          : const EdgeInsets.only(right: 12),
                      // 탭 시 상세 페이지로 이동
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                movieId: movie.id,
                                heroTag: 'movie-$label-$index',
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              ),
                            ),
                          );
                        },

                        // Hero 애니메이션 적용
                        child: orderByPopular
                            // [인기순]일 경우
                            ? Stack(
                                clipBehavior: Clip.none, // 영역 밖으로 나가도 보임
                                children: [
                                  Hero(
                                    tag: 'movie-$label-$index',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      // 포스터 이미지 로드
                                      child: Image.network(
                                        movie.posterPath.isNotEmpty
                                            ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                                            : 'https://picsum.photos/500/700',
                                        width: 120,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // 순위 번호 표시
                                  Positioned(
                                    bottom: -10,
                                    left: -20,
                                    child: Text(
                                      '${index + 1}',
                                      style: AppTheme.headerStyle,
                                    ),
                                  ),
                                ],
                              )
                            // [인기순]이 아닐 경우
                            : Hero(
                                tag: 'movie-$label-$index',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    movie.posterPath.isNotEmpty
                                        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                                        : 'https://picsum.photos/500/700',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
