import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_movie_info_app/data/data_source/movie_data_source_impl.dart';
import 'package:flutter_movie_info_app/data/repository/movie_repository_impl.dart';
import 'package:flutter_movie_info_app/domain/usecase/movie_usecase.dart';

// DataSource Provider
final movieDataSourceProvider = Provider((ref) => MovieDataSourceImpl());

// Repository Provider
final movieRepositoryProvider = Provider(
  (ref) => MovieRepositoryImpl(ref.read(movieDataSourceProvider)),
);

// UseCase Providers
final getNowPlayingMoviesUseCaseProvider = Provider(
  (ref) => GetNowPlayingMoviesUseCase(ref.read(movieRepositoryProvider)),
);

final getPopularMoviesUseCaseProvider = Provider(
  (ref) => GetPopularMoviesUseCase(ref.read(movieRepositoryProvider)),
);

final getTopRatedMoviesUseCaseProvider = Provider(
  (ref) => GetTopRatedMoviesUseCase(ref.read(movieRepositoryProvider)),
);

final getUpcomingMoviesUseCaseProvider = Provider(
  (ref) => GetUpcomingMoviesUseCase(ref.read(movieRepositoryProvider)),
);

final getMovieDetailUseCaseProvider = Provider(
  (ref) => GetMovieDetailUseCase(ref.read(movieRepositoryProvider)),
);
