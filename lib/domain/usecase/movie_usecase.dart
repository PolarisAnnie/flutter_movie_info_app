import 'package:flutter_movie_info_app/domain/entity/movie.dart';
import 'package:flutter_movie_info_app/domain/entity/movie_detail.dart';
import 'package:flutter_movie_info_app/domain/repository/movie_repository.dart';

class GetNowPlayingMoviesUseCase {
  final MovieRepository repository;
  GetNowPlayingMoviesUseCase(this.repository);
  Future<List<Movie>?> execute() async =>
      await repository.fetchNowPlayingMovies();
}

class GetPopularMoviesUseCase {
  final MovieRepository repository;
  GetPopularMoviesUseCase(this.repository);
  Future<List<Movie>?> execute() async => await repository.fetchPopularMovies();
}

class GetTopRatedMoviesUseCase {
  final MovieRepository repository;
  GetTopRatedMoviesUseCase(this.repository);
  Future<List<Movie>?> execute() async =>
      await repository.fetchTopRatedMovies();
}

class GetUpcomingMoviesUseCase {
  final MovieRepository repository;
  GetUpcomingMoviesUseCase(this.repository);
  Future<List<Movie>?> execute() async =>
      await repository.fetchUpcomingMovies();
}

class GetMovieDetailUseCase {
  final MovieRepository repository;
  GetMovieDetailUseCase(this.repository);
  Future<MovieDetail?> execute(int movieId) async =>
      await repository.fetchMovieDetail(movieId);
}
