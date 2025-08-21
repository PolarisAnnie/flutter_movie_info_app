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
  final bool isLoadingMorePopular;
  final int popularMoviesPage;
  final bool hasMorePopularMovies;

  const HomePageState({
    this.nowPlayingMovies = const [],
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.upcomingMovies = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isLoadingMorePopular = false,
    this.popularMoviesPage = 1,
    this.hasMorePopularMovies = true,
  });

  HomePageState copyWith({
    List<Movie>? nowPlayingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? upcomingMovies,
    bool? isLoading,
    String? errorMessage,
    bool? isLoadingMorePopular,
    int? popularMoviesPage,
    bool? hasMorePopularMovies,
  }) {
    return HomePageState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isLoadingMorePopular: isLoadingMorePopular ?? this.isLoadingMorePopular,
      popularMoviesPage: popularMoviesPage ?? this.popularMoviesPage,
      hasMorePopularMovies: hasMorePopularMovies ?? this.hasMorePopularMovies,
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

  Future<void> refreshAllMovies() async {
    // 상태 초기화 (페이지와 추가 데이터들 리셋)
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      popularMoviesPage: 1, // 페이지 리셋
      hasMorePopularMovies: true, // 더보기 가능 상태로 리셋
      isLoadingMorePopular: false, // 추가 로딩 상태 리셋
    );

    try {
      // 모든 영화 카테고리 새로 로딩
      await Future.wait([
        getNowPlayingMovies(),
        getPopularMovies(), // 첫 페이지만 다시 로딩
        getTopRatedMovies(),
        getUpcomingMovies(),
      ]);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '새로고침 중 오류가 발생했습니다: $e',
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
        state = state.copyWith(
          popularMovies: movies, // 기존 영화들 교체
          popularMoviesPage: 1, // 페이지 리셋
        );
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

  Future<void> loadMorePopularMovies() async {
    print('인기 영화 더 로딩 시작 - 현재 페이지: ${state.popularMoviesPage}');
    if (state.isLoadingMorePopular || !state.hasMorePopularMovies) {
      return;
    }

    state = state.copyWith(isLoadingMorePopular: true);

    try {
      final nextPage = state.popularMoviesPage + 1;
      final newMovies = await _getPopularMoviesUseCase.execute(); // 기존 메서드 사용

      if (newMovies != null && newMovies.isNotEmpty) {
        final updatedMovies = [...state.popularMovies, ...newMovies];
        print('새로운 영화 ${newMovies.length}개 추가됨!');
        print(
          '총 영화 개수: ${state.popularMovies.length} → ${updatedMovies.length}',
        );

        state = state.copyWith(
          popularMovies: updatedMovies,
          popularMoviesPage: nextPage,
          isLoadingMorePopular: false,
          hasMorePopularMovies: newMovies.length >= 20,
        );
      } else {
        state = state.copyWith(
          isLoadingMorePopular: false,
          hasMorePopularMovies: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingMorePopular: false,
        errorMessage: '추가 영화를 불러오는 중 오류가 발생했습니다: $e',
      );
    }
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
