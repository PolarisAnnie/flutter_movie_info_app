import 'package:flutter_movie_info_app/presentation/pages/home/home_view_model.dart';
import 'package:flutter_movie_info_app/presentation/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_movie_info_app/domain/entity/movie.dart';
import 'package:flutter_movie_info_app/domain/usecase/movie_usecase.dart';

class MockGetNowPlayingMoviesUseCase extends Mock
    implements GetNowPlayingMoviesUseCase {}

class MockGetPopularMoviesUseCase extends Mock
    implements GetPopularMoviesUseCase {}

class MockGetTopRatedMoviesUseCase extends Mock
    implements GetTopRatedMoviesUseCase {}

class MockGetUpcomingMoviesUseCase extends Mock
    implements GetUpcomingMoviesUseCase {}

void main() {
  late ProviderContainer container;
  late MockGetNowPlayingMoviesUseCase mockGetNowPlayingMoviesUseCase;
  late MockGetPopularMoviesUseCase mockGetPopularMoviesUseCase;
  late MockGetTopRatedMoviesUseCase mockGetTopRatedMoviesUseCase;
  late MockGetUpcomingMoviesUseCase mockGetUpcomingMoviesUseCase;

  setUp(() {
    mockGetNowPlayingMoviesUseCase = MockGetNowPlayingMoviesUseCase();
    mockGetPopularMoviesUseCase = MockGetPopularMoviesUseCase();
    mockGetTopRatedMoviesUseCase = MockGetTopRatedMoviesUseCase();
    mockGetUpcomingMoviesUseCase = MockGetUpcomingMoviesUseCase();

    container = ProviderContainer(
      overrides: [
        getNowPlayingMoviesUseCaseProvider.overrideWithValue(
          mockGetNowPlayingMoviesUseCase,
        ),
        getPopularMoviesUseCaseProvider.overrideWithValue(
          mockGetPopularMoviesUseCase,
        ),
        getTopRatedMoviesUseCaseProvider.overrideWithValue(
          mockGetTopRatedMoviesUseCase,
        ),
        getUpcomingMoviesUseCaseProvider.overrideWithValue(
          mockGetUpcomingMoviesUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('HomePageViewModel - Riverpod 기반', () {
    test('초기 상태가 올바르게 설정되어야 한다', () {
      // Given & When
      final initialState = container.read(homePageViewModelProvider);

      // Then
      expect(initialState.nowPlayingMovies, isEmpty);
      expect(initialState.popularMovies, isEmpty);
      expect(initialState.topRatedMovies, isEmpty);
      expect(initialState.upcomingMovies, isEmpty);
      expect(initialState.isLoading, isFalse);
      expect(initialState.errorMessage, isNull);
    });

    test('getNowPlayingMovies 성공 시 상태가 업데이트된다', () async {
      // Given
      final mockMovies = [
        Movie(id: 1, posterPath: '/poster1.jpg'),
        Movie(id: 2, posterPath: '/poster2.jpg'),
      ];

      when(
        () => mockGetNowPlayingMoviesUseCase.execute(),
      ).thenAnswer((_) async => mockMovies);

      // When
      // Provider 초기화를 위해 먼저 read() 호출
      final viewModel = container.read(homePageViewModelProvider.notifier);
      await viewModel.getNowPlayingMovies();

      // Then
      final state = container.read(homePageViewModelProvider);
      expect(state.nowPlayingMovies.length, equals(2));
      expect(state.nowPlayingMovies[0].id, equals(1));
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('UseCase에서 null 반환 시 에러 메시지가 설정된다', () async {
      // Given
      when(
        () => mockGetNowPlayingMoviesUseCase.execute(),
      ).thenAnswer((_) async => null);

      // When
      // Provider 초기화를 위해 먼저 read() 호출
      final viewModel = container.read(homePageViewModelProvider.notifier);
      await viewModel.getNowPlayingMovies();

      // Then
      final state = container.read(homePageViewModelProvider);
      expect(state.nowPlayingMovies, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, equals('현재 상영중인 영화를 불러올 수 없습니다'));
    });

    test('예외 발생 시 에러 메시지가 설정된다', () async {
      // Given
      when(
        () => mockGetNowPlayingMoviesUseCase.execute(),
      ).thenThrow(Exception('Network error'));

      // When
      // Provider 초기화를 위해 먼저 read() 호출
      final viewModel = container.read(homePageViewModelProvider.notifier);
      await viewModel.getNowPlayingMovies();

      // Then
      final state = container.read(homePageViewModelProvider);
      expect(state.nowPlayingMovies, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, contains('현재 상영중인 영화를 불러오는 중 오류가 발생했습니다'));
    });

    test('clearError가 에러 메시지를 초기화한다', () async {
      // Given - 에러 상태 만들기
      when(
        () => mockGetNowPlayingMoviesUseCase.execute(),
      ).thenAnswer((_) async => null);

      // Provider 초기화를 위해 먼저 read() 호출
      final viewModel = container.read(homePageViewModelProvider.notifier);
      await viewModel.getNowPlayingMovies();

      var state = container.read(homePageViewModelProvider);
      expect(state.errorMessage, isNotNull);

      // When
      viewModel.clearError();

      // Then
      state = container.read(homePageViewModelProvider);
      expect(state.errorMessage, isNull);
    });

    // 모든 영화 로딩 테스트
    test('loadAllMovies가 모든 영화 카테고리를 로딩한다', () async {
      // Given
      final mockNowPlayingMovies = [Movie(id: 1, posterPath: '/poster1.jpg')];
      final mockPopularMovies = [Movie(id: 2, posterPath: '/poster2.jpg')];
      final mockTopRatedMovies = [Movie(id: 3, posterPath: '/poster3.jpg')];
      final mockUpcomingMovies = [Movie(id: 4, posterPath: '/poster4.jpg')];

      when(
        () => mockGetNowPlayingMoviesUseCase.execute(),
      ).thenAnswer((_) async => mockNowPlayingMovies);
      when(
        () => mockGetPopularMoviesUseCase.execute(),
      ).thenAnswer((_) async => mockPopularMovies);
      when(
        () => mockGetTopRatedMoviesUseCase.execute(),
      ).thenAnswer((_) async => mockTopRatedMovies);
      when(
        () => mockGetUpcomingMoviesUseCase.execute(),
      ).thenAnswer((_) async => mockUpcomingMovies);

      // When
      // Provider 초기화를 위해 먼저 read() 호출
      final viewModel = container.read(homePageViewModelProvider.notifier);
      await viewModel.loadAllMovies();

      // Then
      final state = container.read(homePageViewModelProvider);
      expect(state.nowPlayingMovies.length, equals(1));
      expect(state.popularMovies.length, equals(1));
      expect(state.topRatedMovies.length, equals(1));
      expect(state.upcomingMovies.length, equals(1));
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);

      // 모든 UseCase가 호출되었는지 확인
      verify(() => mockGetNowPlayingMoviesUseCase.execute()).called(1);
      verify(() => mockGetPopularMoviesUseCase.execute()).called(1);
      verify(() => mockGetTopRatedMoviesUseCase.execute()).called(1);
      verify(() => mockGetUpcomingMoviesUseCase.execute()).called(1);
    });
  });
}
