import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/domain/entity/movie.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/detail_page.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

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
    if (movies.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.titleStyle),
          SizedBox(height: 10),
          Text('영화 정보가 없습니다', style: TextStyle(color: Colors.grey)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.titleStyle),
        SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // 스크롤이 끝에 가까이 왔을 때 더 로딩
              if (orderByPopular &&
                  onLoadMore != null &&
                  !isLoadingMore &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 100) {
                onLoadMore!();
              }
              return false;
            },
            child: ListView.builder(
              itemCount:
                  movies.length + (orderByPopular && isLoadingMore ? 1 : 0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (orderByPopular && index == movies.length && isLoadingMore) {
                  return Container(
                    width: 120,
                    height: 180,
                    margin: EdgeInsets.only(right: 12),
                    child: Center(
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
                      padding: orderByPopular
                          ? const EdgeInsets.only(right: 24)
                          : const EdgeInsets.only(right: 12),
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
                        child: orderByPopular
                            ? Stack(
                                clipBehavior: Clip.none, // 영역 밖으로 나가도 보이게
                                children: [
                                  Hero(
                                    tag: 'movie-$label-$index',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
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
