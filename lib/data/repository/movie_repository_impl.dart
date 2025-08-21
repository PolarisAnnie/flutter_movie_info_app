import 'package:flutter_movie_info_app/data/data_source/movie_data_source.dart';
import 'package:flutter_movie_info_app/domain/entity/movie.dart';
import 'package:flutter_movie_info_app/domain/entity/movie_detail.dart';
import 'package:flutter_movie_info_app/domain/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(this._movieDataSource);
  final MovieDataSource _movieDataSource;

  @override
  Future<MovieDetail?> fetchMovieDetail(int id) async {
    final result = await _movieDataSource.fetchMovieDetail(id);
    if (result == null) return null;

    return MovieDetail(
      budget: result.budget,
      genres: result.genres.map((genre) => genre.name).toList(),
      id: result.id,
      productionCompanyLogos: result.productionCompanies
          .map((company) => company.logoPath ?? '')
          .toList(),
      overview: result.overview,
      popularity: result.popularity,
      releaseDate: result.releaseDate!,
      revenue: result.revenue,
      runtime: result.runtime,
      tagline: result.tagline,
      title: result.title,
      voteAverage: result.voteAverage,
      voteCount: result.voteCount,
    );
  }

  @override
  Future<List<Movie>?> fetchNowPlayingMovies() async {
    final result = await _movieDataSource.fetchNowPlayingMovies();
    if (result == null) return null;

    return result.results
        .map((dto) => Movie(id: dto.id, posterPath: dto.posterPath ?? ''))
        .toList();
  }

  @override
  Future<List<Movie>?> fetchPopularMovies() async {
    final result = await _movieDataSource.fetchPopularMovies();
    if (result == null) return null;

    return result.results
        .map((dto) => Movie(id: dto.id, posterPath: dto.posterPath ?? ''))
        .toList();
  }

  @override
  Future<List<Movie>?> fetchTopRatedMovies() async {
    final result = await _movieDataSource.fetchTopRatedMovies();
    if (result == null) return null;

    return result.results
        .map((dto) => Movie(id: dto.id, posterPath: dto.posterPath ?? ''))
        .toList();
  }

  @override
  Future<List<Movie>?> fetchUpcomingMovies() async {
    final result = await _movieDataSource.fetchUpcomingMovies();
    if (result == null) return null;

    return result.results
        .map((dto) => Movie(id: dto.id, posterPath: dto.posterPath ?? ''))
        .toList();
  }
}
