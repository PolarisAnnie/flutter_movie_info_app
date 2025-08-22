import 'package:flutter_movie_info_app/data/data_source/movie_data_source.dart';
import 'package:flutter_movie_info_app/domain/entity/movie.dart';
import 'package:flutter_movie_info_app/domain/entity/movie_detail.dart';
import 'package:flutter_movie_info_app/domain/repository/movie_repository.dart';

// MovieRepository 인터페이스를 구현하는 클래스
// 데이터 소스(API 등)에서 데이터를 가져와 도메인 엔티티로 변환하는 역할
class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(this._movieDataSource);
  final MovieDataSource _movieDataSource;

  @override
  Future<MovieDetail?> fetchMovieDetail(int id) async {
    // 데이터 소스에서 영화 상세 정보 DTO 가져오기
    final result = await _movieDataSource.fetchMovieDetail(id);
    if (result == null) return null;

    // DTO를 도메인 엔티티(MovieDetail)로 변환
    return MovieDetail(
      budget: result.budget,
      genres: result.genres.map((genre) => genre.name).toList(), // 장르 이름만 추출
      id: result.id,
      productionCompanyLogos: result.productionCompanies
          .map((company) => company.logoPath ?? '')
          .toList(), // 로고 경로 추출 (null이면 빈 문자열)
      productionCompanyNames: result.productionCompanies
          .map((company) => company.name)
          .toList(), // 회사 이름 추출
      overview: result.overview,
      popularity: result.popularity,
      releaseDate: result.releaseDate!, // null이 아님을 보장
      revenue: result.revenue,
      runtime: result.runtime,
      tagline: result.tagline,
      title: result.title,
      voteAverage: result.voteAverage,
      voteCount: result.voteCount,
      posterPath: result.posterPath,
    );
  }

  @override
  Future<List<Movie>?> fetchNowPlayingMovies() async {
    // 데이터 소스에서 현재 상영 영화 목록 DTO 가져오기
    final result = await _movieDataSource.fetchNowPlayingMovies();
    if (result == null) return null;

    // DTO 리스트를 도메인 엔티티(Movie) 리스트로 변환
    return result.results
        .map((dto) => Movie(id: dto.id, posterPath: dto.posterPath ?? ''))
        .toList();
  }

  @override
  Future<List<Movie>?> fetchPopularMovies() async {
    // 데이터 소스에서 인기 영화 목록 DTO 가져오기
    final result = await _movieDataSource.fetchPopularMovies();
    if (result == null) return null;

    // DTO 리스트를 도메인 엔티티(Movie) 리스트로 변환
    return result.results
        .map((dto) => Movie(id: dto.id, posterPath: dto.posterPath ?? ''))
        .toList();
  }

  @override
  Future<List<Movie>?> fetchTopRatedMovies() async {
    // 데이터 소스에서 평점 높은 영화 목록 DTO 가져오기
    final result = await _movieDataSource.fetchTopRatedMovies();
    if (result == null) return null;

    // DTO 리스트를 도메인 엔티티(Movie) 리스트로 변환
    return result.results
        .map((dto) => Movie(id: dto.id, posterPath: dto.posterPath ?? ''))
        .toList();
  }

  @override
  Future<List<Movie>?> fetchUpcomingMovies() async {
    // 데이터 소스에서 개봉 예정 영화 목록 DTO 가져오기
    final result = await _movieDataSource.fetchUpcomingMovies();
    if (result == null) return null;

    // DTO 리스트를 도메인 엔티티(Movie) 리스트로 변환
    return result.results
        .map((dto) => Movie(id: dto.id, posterPath: dto.posterPath ?? ''))
        .toList();
  }
}
