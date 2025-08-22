import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/detail_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/box_office_section.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/divider_line.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/genre_list.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/movie_info_section.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/production_gallery.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

class DetailPage extends ConsumerStatefulWidget {
  const DetailPage({super.key, required this.heroTag, required this.movieId});

  final String heroTag;
  final int movieId;

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(detailPageViewModelProvider.notifier)
          .getMovieDetail(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailPageViewModelProvider);

    if (state.isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('에러 발생!'),
              Text(state.errorMessage!),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(detailPageViewModelProvider.notifier)
                      .getMovieDetail(widget.movieId);
                },
                child: Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    final movieDetail = state.movieDetail;
    if (movieDetail == null) {
      return Scaffold(body: Center(child: Text('영화 정보가 없습니다')));
    }

    print('🏢 제작사 로고들: ${movieDetail.productionCompanyLogos}');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              width: double.infinity,
              child: Hero(
                tag: widget.heroTag,
                child: ClipRRect(
                  // 이렇게 수정
                  child: Image.network(
                    movieDetail.posterPath != null &&
                            movieDetail.posterPath!.isNotEmpty
                        ? 'https://image.tmdb.org/t/p/w500${movieDetail.posterPath}'
                        : 'https://picsum.photos/500/700',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('🔴 이미지 로딩 실패: ${movieDetail.posterPath}');
                      return Image.network(
                        'https://picsum.photos/500/700',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MovieInfoSection(
                    title: movieDetail.title,
                    releaseDate: movieDetail.releaseDate.toString().split(
                      ' ',
                    )[0], // DateTime → String
                    tagline: movieDetail.tagline,
                    runtime: '${movieDetail.runtime}분',
                  ),
                  SizedBox(height: 8),
                  DividerLine(),
                  SizedBox(height: 8),
                  GenreList(genres: movieDetail.genres),
                  SizedBox(height: 8),
                  DividerLine(),
                  SizedBox(height: 8),
                  Text(movieDetail.overview, style: AppTheme.bodyStyle),
                  SizedBox(height: 8),
                  DividerLine(),
                  SizedBox(height: 20),
                  BoxOfficeSection(
                    voteAverage: movieDetail.voteAverage,
                    voteCount: movieDetail.voteCount,
                    popularity: movieDetail.popularity,
                    budget: movieDetail.budget,
                    revenue: movieDetail.revenue,
                  ),
                  SizedBox(height: 12),
                  ProductionGallery(
                    productionImageUrls: movieDetail.productionCompanyLogos
                        .map(
                          (logoPath) =>
                              'https://image.tmdb.org/t/p/w154$logoPath',
                        )
                        .toList(),
                    productionCompanyNames: movieDetail.productionCompanyNames,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
