import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_movie_info_app/data/data_source/movie_data_source_impl.dart';
import 'package:flutter_movie_info_app/data/repository/movie_repository_impl.dart';
import 'package:flutter_movie_info_app/domain/usecase/movie_usecase.dart';
import 'package:http/http.dart' as http;

// API 토큰을 관리하는 Provider
final accessTokenProvider = Provider<String>((ref) {
  // .env 파일에서 TMDB_ACCESS_TOKEN을 로드합니다.
  final token = dotenv.env['TMDB_ACCESS_TOKEN'];
  if (token == null || token.isEmpty) {
    throw Exception("TMDB_ACCESS_TOKEN is not found in .env file.");
  }
  return token;
});

// HTTP 클라이언트를 관리하는 Provider
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// DataSource Provider: accessToken과 httpClient를 의존성으로 주입받도록 수정
final movieDataSourceProvider = Provider((ref) {
  final accessToken = ref.watch(accessTokenProvider);
  final httpClient = ref.watch(httpClientProvider);
  return MovieDataSourceImpl(accessToken: accessToken, httpClient: httpClient);
});

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
