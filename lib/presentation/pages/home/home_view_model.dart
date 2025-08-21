// home_view_model.dart

import 'package:flutter_movie_info_app/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_movie_info_app/domain/entity/movie.dart';
import 'package:flutter_movie_info_app/domain/usecase/movie_usecase.dart';

class HomePageState {
  final List<Movie> nowPlayingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;
  final bool isLoading;
  final String? errorMessage;

  const HomePageState({
    this.nowPlayingMovies = const [],
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.upcomingMovies = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  HomePageState copyWith({
    List<Movie>? nowPlayingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? upcomingMovies,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomePageState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class HomePageViewModel extends StateNotifier<HomePageState> {
  final GetNowPlayingMoviesUseCase _getNowPlayingMoviesUseCase;
  final GetPopularMoviesUseCase _getPopularMoviesUseCase;
  final GetTopRatedMoviesUseCase _getTopRatedMoviesUseCase;
  final GetUpcomingMoviesUseCase _getUpcomingMoviesUseCase;

  HomePageViewModel({
    required GetNowPlayingMoviesUseCase getNowPlayingMoviesUseCase,
    required GetPopularMoviesUseCase getPopularMoviesUseCase,
    required GetTopRatedMoviesUseCase getTopRatedMoviesUseCase,
    required GetUpcomingMoviesUseCase getUpcomingMoviesUseCase,
  }) : _getNowPlayingMoviesUseCase = getNowPlayingMoviesUseCase,
       _getPopularMoviesUseCase = getPopularMoviesUseCase,
       _getTopRatedMoviesUseCase = getTopRatedMoviesUseCase,
       _getUpcomingMoviesUseCase = getUpcomingMoviesUseCase,
       super(const HomePageState());

  Future<void> loadAllMovies() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.wait([
        getNowPlayingMovies(),
        getPopularMovies(),
        getTopRatedMovies(),
        getUpcomingMovies(),
      ]);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '영화 데이터를 불러오는 중 오류가 발생했습니다: $e',
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getNowPlayingMovies() async {
    try {
      final movies = await _getNowPlayingMoviesUseCase.execute();
      if (movies != null) {
        state = state.copyWith(nowPlayingMovies: movies);
      } else {
        state = state.copyWith(errorMessage: '현재 상영중인 영화를 불러올 수 없습니다');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '현재 상영중인 영화를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> getPopularMovies() async {
    try {
      final movies = await _getPopularMoviesUseCase.execute();
      if (movies != null) {
        state = state.copyWith(popularMovies: movies);
      } else {
        state = state.copyWith(errorMessage: '인기 영화를 불러올 수 없습니다');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '인기 영화를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> getTopRatedMovies() async {
    try {
      final movies = await _getTopRatedMoviesUseCase.execute();
      if (movies != null) {
        state = state.copyWith(topRatedMovies: movies);
      } else {
        state = state.copyWith(errorMessage: '평점 높은 영화를 불러올 수 없습니다');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '평점 높은 영화를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> getUpcomingMovies() async {
    try {
      final movies = await _getUpcomingMoviesUseCase.execute();
      if (movies != null) {
        state = state.copyWith(upcomingMovies: movies);
      } else {
        state = state.copyWith(errorMessage: '개봉 예정 영화를 불러올 수 없습니다');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '개봉 예정 영화를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Provider 정의
final homePageViewModelProvider =
    StateNotifierProvider<HomePageViewModel, HomePageState>((ref) {
      return HomePageViewModel(
        getNowPlayingMoviesUseCase: ref.read(
          getNowPlayingMoviesUseCaseProvider,
        ),
        getPopularMoviesUseCase: ref.read(getPopularMoviesUseCaseProvider),
        getTopRatedMoviesUseCase: ref.read(getTopRatedMoviesUseCaseProvider),
        getUpcomingMoviesUseCase: ref.read(getUpcomingMoviesUseCaseProvider),
      );
    });
