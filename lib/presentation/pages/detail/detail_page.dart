import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/detail_page_view_model.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/review_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/box_office_section.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/divider_line.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/genre_list.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/movie_info_section.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/production_gallery.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

// 영화 상세 정보를 표시하는 페이지 위젯
class DetailPage extends ConsumerStatefulWidget {
  const DetailPage({
    super.key,
    required this.heroTag,
    required this.movieId,
    required this.imageUrl,
  });

  final String heroTag; // Hero 애니메이션 태그
  final int movieId; // 상세 정보를 가져올 영화 ID
  final String imageUrl; // 히어로 이미지 URL

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  void initState() {
    super.initState();
    // 위젯이 빌드된 후 한 번만 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(detailPageViewModelProvider.notifier)
          .getMovieDetail(widget.movieId); // 영화 상세 정보 가져오기
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailPageViewModelProvider); // ViewModel 상태 감시

    // 로딩 상태일 때 로딩 인디케이터 표시
    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 에러 발생 시 에러 메시지 및 다시 시도 버튼 표시
    if (state.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('에러 발생!'),
              Text(state.errorMessage!),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(detailPageViewModelProvider.notifier)
                      .getMovieDetail(widget.movieId); // 영화 정보 재요청
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    final movieDetail = state.movieDetail;
    // 영화 정보가 없을 때 메시지 표시
    if (movieDetail == null) {
      return const Scaffold(body: Center(child: Text('영화 정보가 없습니다')));
    }

    // 데이터가 있을 때 상세 정보 페이지 빌드
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              width: double.infinity,
              // Hero 위젯으로 메인 이미지 애니메이션 효과
              child: Hero(
                tag: widget.heroTag,
                child: ClipRRect(
                  // 이미지 네트워크 로드 및 오류 처리
                  child: Image.network(
                    movieDetail.posterPath != null &&
                            movieDetail.posterPath!.isNotEmpty
                        ? widget.imageUrl
                        : 'https://picsum.photos/500/700', // 포스터 이미지 없으면 대체 이미지 사용
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://picsum.photos/500/700', // 이미지 로드 실패 시 대체 이미지
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
                    )[0], // 개봉일 포맷팅
                    tagline: movieDetail.tagline,
                    runtime: '${movieDetail.runtime}분',
                  ),
                  const SizedBox(height: 8),
                  const DividerLine(), // 구분선 표시
                  const SizedBox(height: 8),
                  GenreList(genres: movieDetail.genres), // 장르 리스트 표시
                  const SizedBox(height: 8),
                  const DividerLine(), // 구분선 표시
                  const SizedBox(height: 8),
                  // 오버뷰가 있을 경우에만 섹션 표시
                  if (movieDetail.overview.isNotEmpty) ...[
                    Text(movieDetail.overview, style: AppTheme.bodyStyle),
                    const SizedBox(height: 8),
                    const DividerLine(),
                  ],
                  const SizedBox(height: 20),
                  ReviewSection(
                    movieTitle: movieDetail.title,
                    movieYear: movieDetail.releaseDate.year,
                  ), // 나만의 기능: 리뷰 섹션 추가
                  const SizedBox(height: 20),
                  const DividerLine(),
                  const SizedBox(height: 20),
                  BoxOfficeSection(
                    voteAverage: movieDetail.voteAverage,
                    voteCount: movieDetail.voteCount,
                    popularity: movieDetail.popularity,
                    budget: movieDetail.budget,
                    revenue: movieDetail.revenue,
                  ),
                  const SizedBox(height: 12),
                  ProductionGallery(
                    productionImageUrls: movieDetail.productionCompanyLogos
                        .map(
                          (logoPath) =>
                              'https://image.tmdb.org/t/p/w154$logoPath',
                        )
                        .toList(), // 로고 URL 생성
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
