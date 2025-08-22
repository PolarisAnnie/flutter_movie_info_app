import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_movie_info_app/domain/entity/movie.dart';
import 'package:flutter_movie_info_app/domain/entity/movie_detail.dart';
import 'package:flutter_movie_info_app/domain/repository/movie_repository.dart';
import 'package:flutter_movie_info_app/domain/usecase/movie_usecase.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockMovieRepository;
  late GetNowPlayingMoviesUseCase getNowPlayingMoviesUseCase;
  late GetPopularMoviesUseCase getPopularMoviesUseCase;
  late GetTopRatedMoviesUseCase getTopRatedMoviesUseCase;
  late GetUpcomingMoviesUseCase getUpcomingMoviesUseCase;
  late GetMovieDetailUseCase getMovieDetailUseCase;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    getNowPlayingMoviesUseCase = GetNowPlayingMoviesUseCase(
      mockMovieRepository,
    );
    getPopularMoviesUseCase = GetPopularMoviesUseCase(mockMovieRepository);
    getTopRatedMoviesUseCase = GetTopRatedMoviesUseCase(mockMovieRepository);
    getUpcomingMoviesUseCase = GetUpcomingMoviesUseCase(mockMovieRepository);
    getMovieDetailUseCase = GetMovieDetailUseCase(mockMovieRepository);
  });

  group('GetNowPlayingMoviesUseCase', () {
    test('성공적으로 현재 상영중인 영화 목록을 가져온다', () async {
      // Given
      final mockMovies = [
        Movie(id: 1, posterPath: '/poster1.jpg'),
        Movie(id: 2, posterPath: '/poster2.jpg'),
      ];

      when(
        () => mockMovieRepository.fetchNowPlayingMovies(),
      ).thenAnswer((_) async => mockMovies);

      // When
      final result = await getNowPlayingMoviesUseCase.execute();

      // Then
      expect(result, isNotNull);
      expect(result!.length, equals(2));
      expect(result[0].id, equals(1));
      expect(result[0].posterPath, equals('/poster1.jpg'));

      verify(() => mockMovieRepository.fetchNowPlayingMovies()).called(1);
    });

    test('Repository에서 null 반환 시 null을 반환한다', () async {
      // Given
      when(
        () => mockMovieRepository.fetchNowPlayingMovies(),
      ).thenAnswer((_) async => null);

      // When
      final result = await getNowPlayingMoviesUseCase.execute();

      // Then
      expect(result, isNull);
      verify(() => mockMovieRepository.fetchNowPlayingMovies()).called(1);
    });
  });

  group('GetPopularMoviesUseCase', () {
    test('성공적으로 인기 영화 목록을 가져온다', () async {
      // Given
      final mockMovies = [Movie(id: 533535, posterPath: '/deadpool.jpg')];

      when(
        () => mockMovieRepository.fetchPopularMovies(),
      ).thenAnswer((_) async => mockMovies);

      // When
      final result = await getPopularMoviesUseCase.execute();

      // Then
      expect(result, isNotNull);
      expect(result!.length, equals(1));
      expect(result[0].id, equals(533535));

      verify(() => mockMovieRepository.fetchPopularMovies()).called(1);
    });
  });

  group('GetTopRatedMoviesUseCase', () {
    test('성공적으로 최고 평점 영화 목록을 가져온다', () async {
      // Given
      final mockMovies = [Movie(id: 278, posterPath: '/shawshank.jpg')];

      when(
        () => mockMovieRepository.fetchTopRatedMovies(),
      ).thenAnswer((_) async => mockMovies);

      // When
      final result = await getTopRatedMoviesUseCase.execute();

      // Then
      expect(result, isNotNull);
      expect(result!.length, equals(1));
      expect(result[0].id, equals(278));

      verify(() => mockMovieRepository.fetchTopRatedMovies()).called(1);
    });
  });

  group('GetUpcomingMoviesUseCase', () {
    test('성공적으로 개봉 예정 영화 목록을 가져온다', () async {
      // Given
      final mockMovies = [Movie(id: 1184918, posterPath: '/robot.jpg')];

      when(
        () => mockMovieRepository.fetchUpcomingMovies(),
      ).thenAnswer((_) async => mockMovies);

      // When
      final result = await getUpcomingMoviesUseCase.execute();

      // Then
      expect(result, isNotNull);
      expect(result!.length, equals(1));
      expect(result[0].id, equals(1184918));

      verify(() => mockMovieRepository.fetchUpcomingMovies()).called(1);
    });
  });

  group('GetMovieDetailUseCase', () {
    test('성공적으로 영화 상세 정보를 가져온다', () async {
      // Given
      final mockMovieDetail = MovieDetail(
        budget: 200000000,
        genres: ['액션', '코미디'],
        id: 533535,
        productionCompanyLogos: ['/logo1.png', '/logo2.png'],
        overview: '자칭 마블의 구원자...',
        popularity: 1500.5,
        releaseDate: DateTime(2024, 7, 24),
        revenue: 1300000000,
        runtime: 128,
        tagline: '최고의 팀업',
        title: '데드풀과 울버린',
        voteAverage: 7.7,
        voteCount: 5000,
        productionCompanyNames: ['Disney'],
      );

      when(
        () => mockMovieRepository.fetchMovieDetail(533535),
      ).thenAnswer((_) async => mockMovieDetail);

      // When
      final result = await getMovieDetailUseCase.execute(533535);

      // Then
      expect(result, isNotNull);
      expect(result!.id, equals(533535));
      expect(result.title, equals('데드풀과 울버린'));
      expect(result.budget, equals(200000000));
      expect(result.runtime, equals(128));
      expect(result.genres.length, equals(2));

      verify(() => mockMovieRepository.fetchMovieDetail(533535)).called(1);
    });

    test('Repository에서 null 반환 시 null을 반환한다', () async {
      // Given
      when(
        () => mockMovieRepository.fetchMovieDetail(999999),
      ).thenAnswer((_) async => null);

      // When
      final result = await getMovieDetailUseCase.execute(999999);

      // Then
      expect(result, isNull);
      verify(() => mockMovieRepository.fetchMovieDetail(999999)).called(1);
    });

    test('잘못된 ID로 요청 시 예외를 전파한다', () async {
      // Given
      when(
        () => mockMovieRepository.fetchMovieDetail(-1),
      ).thenThrow(Exception('Invalid movie ID'));

      // When & Then
      expect(
        () => getMovieDetailUseCase.execute(-1),
        throwsA(isA<Exception>()),
      );

      verify(() => mockMovieRepository.fetchMovieDetail(-1)).called(1);
    });
  });

  group('모든 UseCase 통합 테스트', () {
    test('Repository 의존성이 올바르게 주입되었는지 확인', () {
      // Then
      expect(
        getNowPlayingMoviesUseCase.repository,
        equals(mockMovieRepository),
      );
      expect(getPopularMoviesUseCase.repository, equals(mockMovieRepository));
      expect(getTopRatedMoviesUseCase.repository, equals(mockMovieRepository));
      expect(getUpcomingMoviesUseCase.repository, equals(mockMovieRepository));
      expect(getMovieDetailUseCase.repository, equals(mockMovieRepository));
    });
  });
}
