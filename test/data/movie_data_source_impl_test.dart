import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_movie_info_app/data/data_source/movie_data_source_impl.dart';

// Mock HTTP Client 클래스
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MovieDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  // mocktail을 위한 fallback 값 등록
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://fallback.com'));
  });

  // 각 테스트 전 Mock 객체 생성
  setUp(() {
    mockHttpClient = MockHttpClient();
    // accessToken 매개변수에 더미 값 ('test_api_key') 전달
    dataSource = MovieDataSourceImpl(
      httpClient: mockHttpClient,
      accessToken: 'test_api_key',
    );
  });

  // 각 테스트 후 Mock 상태 초기화
  tearDown(() {
    reset(mockHttpClient);
  });

  group('MovieDataSourceImpl - fetchNowPlayingMovies', () {
    test('성공적으로 현재 상영중인 영화 목록을 가져온다', () async {
      // Given
      const movieJson = '''
{
  "page": 1,
  "results": [
    {
      "id": 1022789,
      "title": "인사이드 아웃 2",
      "overview": "13살이 된 라일리의 행복을 위해 매일 바쁘게...",
      "poster_path": "/pmemGuhr450DK8GiTT44mgwWCP7.jpg",
      "backdrop_path": "/stKGOm8UyhuLPR9sZLjs5AkmncA.jpg",
      "vote_average": 7.6,
      "release_date": "2024-06-11"
    }
  ],
  "total_pages": 42,
  "total_results": 831
}
''';

      final expectedUri = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?language=ko-KR',
      );

      when(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(
          movieJson,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      // When
      final result = await dataSource.fetchNowPlayingMovies();

      // Then
      expect(result, isNotNull);
      expect(result!.page, equals(1));
      expect(result.totalResults, equals(831));
      expect(result.totalPages, equals(42));
      expect(result.results.length, equals(1));

      final movie = result.results[0];
      expect(movie.id, equals(1022789));
      expect(movie.title, equals('인사이드 아웃 2'));
      expect(movie.voteAverage, equals(7.6));
      expect(movie.posterPath, equals('/pmemGuhr450DK8GiTT44mgwWCP7.jpg'));

      verify(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).called(1);
    });

    test('HTTP 404 에러일 때 null을 반환한다', () async {
      // Given
      final expectedUri = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?language=ko-KR',
      );

      when(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      // When
      final result = await dataSource.fetchNowPlayingMovies();

      // Then
      expect(result, isNull);
    });

    test('네트워크 에러일 때 null을 반환한다', () async {
      // Given
      final expectedUri = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?language=ko-KR',
      );

      when(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).thenThrow(Exception('Network error'));

      // When
      final result = await dataSource.fetchNowPlayingMovies();

      // Then
      expect(result, isNull);
    });

    test('잘못된 JSON 응답일 때 null을 반환한다', () async {
      // Given
      final expectedUri = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?language=ko-KR',
      );

      when(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(
          'invalid json',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      // When
      final result = await dataSource.fetchNowPlayingMovies();

      // Then
      expect(result, isNull);
    });
  });

  group('MovieDataSourceImpl - fetchPopularMovies', () {
    test('성공적으로 인기 영화 목록을 가져온다', () async {
      // Given
      const movieJson = '''
{
  "page": 1,
  "results": [
    {
      "id": 533535,
      "title": "데드풀과 울버린",
      "overview": "자칭 마블의 구원자 데드풀이 울버린을...",
      "poster_path": "/4Zb4Z2HjX1t5zr1qYOTdVoisJKp.jpg",
      "backdrop_path": "/yDHYTfA3R0jFYba4Xi9YuF6Q4Q.jpg",
      "vote_average": 7.7,
      "release_date": "2024-07-24"
    }
  ],
  "total_pages": 45678,
  "total_results": 913547
}
''';

      final expectedUri = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?language=ko-KR',
      );

      when(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(
          movieJson,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      // When
      final result = await dataSource.fetchPopularMovies();

      // Then
      expect(result, isNotNull);
      expect(result!.results.length, equals(1));
      expect(result.results[0].title, equals('데드풀과 울버린'));
      expect(result.results[0].voteAverage, equals(7.7));

      verify(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).called(1);
    });

    test('HTTP 에러일 때 null을 반환한다', () async {
      // Given
      final expectedUri = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?language=ko-KR',
      );

      when(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('Server Error', 500));

      // When
      final result = await dataSource.fetchPopularMovies();

      // Then
      expect(result, isNull);
    });
  });

  group('MovieDataSourceImpl - fetchTopRatedMovies', () {
    test('성공적으로 최고 평점 영화 목록을 가져온다', () async {
      // Given
      const movieJson = '''
{
  "page": 1,
  "results": [
    {
      "id": 278,
      "title": "쇼생크 탈출",
      "overview": "은행 부지점장 앤디 듀프레인은 아내와...",
      "poster_path": "/3hO6DIGRBaJQj2NLEYBMwpcz88D.jpg",
      "backdrop_path": "/iNh3BivHyg5sQRPP1KOkzguEX0H.jpg",
      "vote_average": 8.7,
      "release_date": "1994-09-23"
    }
  ],
  "total_pages": 612,
  "total_results": 12230
}
''';

      final expectedUri = Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?language=ko-KR',
      );

      when(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(
          movieJson,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      // When
      final result = await dataSource.fetchTopRatedMovies();

      // Then
      expect(result, isNotNull);
      expect(result!.results[0].title, equals('쇼생크 탈출'));
      expect(result.results[0].voteAverage, equals(8.7));

      verify(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).called(1);
    });
  });

  group('MovieDataSourceImpl - fetchUpcomingMovies', () {
    test('성공적으로 개봉 예정 영화 목록을 가져온다', () async {
      // Given
      const movieJson = '''
{
  "page": 1,
  "results": [
    {
      "id": 1184918,
      "title": "야생의 로봇",
      "overview": "허리케인으로 무인도에 불시착한 로봇...",
      "poster_path": "/wTnV3PCVW5O92JMrFvvrRcV39RU.jpg",
      "backdrop_path": "/417tYZ4XUyJrtyZXj7HpvWf1E8f.jpg",
      "vote_average": 8.1,
      "release_date": "2024-09-12"
    }
  ],
  "total_pages": 15,
  "total_results": 285
}
''';

      final expectedUri = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?language=ko-KR',
      );

      when(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(
          movieJson,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      // When
      final result = await dataSource.fetchUpcomingMovies();

      // Then
      expect(result, isNotNull);
      expect(result!.results[0].title, equals('야생의 로봇'));
      expect(result.results[0].voteAverage, equals(8.1));

      verify(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).called(1);
    });
  });

  group('MovieDataSourceImpl - fetchMovieDetail', () {
    test('성공적으로 영화 상세 정보를 가져온다', () async {
      // Given
      const movieDetailJson = '''
{
  "id": 533535,
  "title": "데드풀과 울버린",
  "overview": "자칭 마블의 구원자 데드풀이 울버린을 만나...",
  "runtime": 128,
  "release_date": "2024-07-24",
  "vote_average": 7.7,
  "poster_path": "/4Zb4Z2HjX1t5zr1qYOTdVoisJKp.jpg",
  "backdrop_path": "/yDHYTfA3R0jFYba4Xi9YuF6Q4Q.jpg",
  "genres": [
    {
      "id": 28,
      "name": "액션"
    },
    {
      "id": 35,
      "name": "코미디"
    }
  ],
  "production_countries": [
    {
      "iso_3166_1": "US",
      "name": "United States of America"
    }
  ]
}
''';

      const movieId = 533535;
      final expectedUri = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?language=ko-KR',
      );

      when(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(
          movieDetailJson,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      // When
      final result = await dataSource.fetchMovieDetail(movieId);

      // Then
      expect(result, isNotNull);
      expect(result!.id, equals(533535));
      expect(result.title, equals('데드풀과 울버린'));
      expect(result.runtime, equals(128));
      expect(result.genres.length, equals(2));
      expect(result.genres[0].name, equals('액션'));

      verify(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).called(1);
    });

    test('존재하지 않는 영화 ID로 요청 시 null을 반환한다', () async {
      // Given
      const invalidMovieId = 999999;
      final expectedUri = Uri.parse(
        'https://api.themoviedb.org/3/movie/$invalidMovieId?language=ko-KR',
      );

      when(
        () => mockHttpClient.get(expectedUri, headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(
          '{"status_code": 34, "status_message": "The resource you requested could not be found."}',
          404,
        ),
      );

      // When
      final result = await dataSource.fetchMovieDetail(invalidMovieId);

      // Then
      expect(result, isNull);
    });
  });

  group('MovieDataSourceImpl - 공통 헤더 검증', () {
    test('모든 요청에 올바른 헤더가 포함되어야 한다', () async {
      // Given
      const simpleJson =
          '{"page": 1, "results": [], "total_pages": 1, "total_results": 1}';

      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => http.Response(
          simpleJson,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );

      // When
      await dataSource.fetchNowPlayingMovies();

      // Then - Authorization 헤더가 Bearer 형식으로 포함되어야 함
      verify(
        () => mockHttpClient.get(
          any(),
          headers: {
            'Authorization': 'Bearer ', // 실제 테스트에서는 빈 문자열 (환경변수 없음)
            'Content-Type': 'application/json',
          },
        ),
      ).called(1);
    });
  });
}
