import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_movie_info_app/data/repository/movie_repository_impl.dart';
import 'package:flutter_movie_info_app/data/data_source/movie_data_source.dart';
import 'package:flutter_movie_info_app/data/dto/movie_response_dto.dart';
import 'package:flutter_movie_info_app/data/dto/movie_detail_dto.dart';
import 'package:flutter_movie_info_app/domain/entity/movie.dart';
import 'package:flutter_movie_info_app/domain/entity/movie_detail.dart';

// Mock DataSource 클래스
class MockMovieDataSource extends Mock implements MovieDataSource {}

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMovieDataSource();
    repository = MovieRepositoryImpl(mockDataSource);
  });

  tearDown(() {
    reset(mockDataSource);
  });

  group('MovieRepositoryImpl - fetchNowPlayingMovies', () {
    test('성공적으로 DTO를 Entity로 변환한다', () async {
      // Given
      final mockResult = Result(
        adult: false,
        genreIds: [16, 28, 14],
        id: 1022789,
        originalLanguage: 'ko',
        originalTitle: 'Inside Out 2',
        overview: '13살이 된 라일리의 행복을 위해...',
        popularity: 307.6,
        title: '인사이드 아웃 2',
        video: false,
        voteAverage: 7.6,
        voteCount: 1000,
        backdropPath: '/stKGOm8UyhuLPR9sZLjs5AkmncA.jpg',
        posterPath: '/pmemGuhr450DK8GiTT44mgwWCP7.jpg',
        releaseDate: DateTime(2024, 6, 11),
      );

      final mockResponseDto = MovieResponseDto(
        page: 1,
        results: [mockResult],
        totalPages: 42,
        totalResults: 831,
      );

      when(
        () => mockDataSource.fetchNowPlayingMovies(),
      ).thenAnswer((_) async => mockResponseDto);

      // When
      final result = await repository.fetchNowPlayingMovies();

      // Then
      expect(result, isNotNull);
      expect(result, isA<List<Movie>>());
      expect(result!.length, equals(1));

      final movie = result[0];
      expect(movie.id, equals(1022789));
      expect(movie.posterPath, equals('/pmemGuhr450DK8GiTT44mgwWCP7.jpg'));

      verify(() => mockDataSource.fetchNowPlayingMovies()).called(1);
    });

    test('posterPath가 null일 때 빈 문자열로 변환한다', () async {
      // Given
      final mockResult = Result(
        adult: false,
        genreIds: [28],
        id: 123,
        originalLanguage: 'en',
        originalTitle: 'Test Movie',
        overview: 'Test overview',
        popularity: 100.0,
        title: 'Test Movie',
        video: false,
        voteAverage: 8.0,
        voteCount: 500,
        backdropPath: '/backdrop.jpg',
        posterPath: null, // null 케이스
        releaseDate: DateTime(2024, 1, 1),
      );

      final mockResponseDto = MovieResponseDto(
        page: 1,
        results: [mockResult],
        totalPages: 1,
        totalResults: 1,
      );

      when(
        () => mockDataSource.fetchNowPlayingMovies(),
      ).thenAnswer((_) async => mockResponseDto);

      // When
      final result = await repository.fetchNowPlayingMovies();

      // Then
      expect(result!.length, equals(1));
      expect(result[0].posterPath, equals('')); // null → 빈 문자열
    });

    test('DataSource에서 null 반환 시 null을 반환한다', () async {
      // Given
      when(
        () => mockDataSource.fetchNowPlayingMovies(),
      ).thenAnswer((_) async => null);

      // When
      final result = await repository.fetchNowPlayingMovies();

      // Then
      expect(result, isNull);
      verify(() => mockDataSource.fetchNowPlayingMovies()).called(1);
    });
  });

  group('MovieRepositoryImpl - fetchMovieDetail', () {
    test('성공적으로 복잡한 DTO를 Entity로 변환한다', () async {
      // Given
      final mockGenres = [
        Genre(id: 28, name: '액션'),
        Genre(id: 35, name: '코미디'),
      ];

      final mockProductionCompanies = [
        ProductionCompany(
          id: 33,
          name: 'Universal Pictures',
          logoPath: '/6exxhPonOo0M995SAchY0ijpRao.png',
          originCountry: 'US',
        ),
        ProductionCompany(
          id: 34,
          name: 'Marvel Studios',
          logoPath: null, // null 케이스
          originCountry: 'US',
        ),
      ];

      final mockDetailDto = MovieDetailDto(
        adult: false,
        budget: 200000000,
        genres: mockGenres,
        homepage: '',
        id: 533535,
        originCountry: ['US'],
        originalLanguage: 'en',
        originalTitle: 'Deadpool & Wolverine',
        overview: '자칭 마블의 구원자...',
        popularity: 1500.5,
        productionCompanies: mockProductionCompanies,
        productionCountries: [],
        revenue: 1300000000,
        runtime: 128,
        spokenLanguages: [],
        status: 'Released',
        tagline: '최고의 팀업',
        title: '데드풀과 울버린',
        video: false,
        voteAverage: 7.7,
        voteCount: 5000,
        backdropPath: '/backdrop.jpg',
        belongsToCollection: null,
        imdbId: 'tt6263850',
        posterPath: '/poster.jpg',
        releaseDate: DateTime(2024, 7, 24),
      );

      when(
        () => mockDataSource.fetchMovieDetail(533535),
      ).thenAnswer((_) async => mockDetailDto);

      // When
      final result = await repository.fetchMovieDetail(533535);

      // Then
      expect(result, isNotNull);
      expect(result, isA<MovieDetail>());

      expect(result!.id, equals(533535));
      expect(result.title, equals('데드풀과 울버린'));
      expect(result.budget, equals(200000000));
      expect(result.runtime, equals(128));

      // 장르 변환 확인
      expect(result.genres.length, equals(2));
      expect(result.genres[0], equals('액션'));
      expect(result.genres[1], equals('코미디'));

      // 제작사 로고 변환 확인
      expect(result.productionCompanyLogos.length, equals(2));
      expect(
        result.productionCompanyLogos[0],
        equals('/6exxhPonOo0M995SAchY0ijpRao.png'),
      );
      expect(result.productionCompanyLogos[1], equals('')); // null → 빈 문자열

      verify(() => mockDataSource.fetchMovieDetail(533535)).called(1);
    });

    test('DataSource에서 null 반환 시 null을 반환한다', () async {
      // Given
      when(
        () => mockDataSource.fetchMovieDetail(999999),
      ).thenAnswer((_) async => null);

      // When
      final result = await repository.fetchMovieDetail(999999);

      // Then
      expect(result, isNull);
      verify(() => mockDataSource.fetchMovieDetail(999999)).called(1);
    });
  });
}
