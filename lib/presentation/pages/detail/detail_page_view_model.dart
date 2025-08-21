import 'package:flutter_movie_info_app/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_movie_info_app/domain/entity/movie_detail.dart';

// DetailPageState 정의
class DetailPageState {
  final MovieDetail? movieDetail;
  final bool isLoading;
  final String? errorMessage;

  DetailPageState({
    this.movieDetail,
    this.isLoading = false,
    this.errorMessage,
  });

  DetailPageState copyWith({
    MovieDetail? movieDetail,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DetailPageState(
      movieDetail: movieDetail ?? this.movieDetail,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// DetailPageViewModel
class DetailPageViewModel extends Notifier<DetailPageState> {
  @override
  DetailPageState build() {
    return DetailPageState();
  }

  // 영화 상세 정보 가져오기
  Future<void> getMovieDetail(int movieId) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        movieDetail: null, // 이전 데이터 초기화
      );

      final result = await ref
          .read(getMovieDetailUseCaseProvider)
          .execute(movieId);

      if (result != null) {
        state = state.copyWith(movieDetail: result, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '영화 상세 정보를 불러올 수 없습니다',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '영화 상세 정보를 불러오는 중 오류가 발생했습니다: $e',
      );
    }
  }

  // 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // 데이터 새로고침
  Future<void> refresh(int movieId) async {
    await getMovieDetail(movieId);
  }

  // ViewModel 초기화 (새로운 영화로 전환 시)
  void reset() {
    state = DetailPageState();
  }
}

// Provider 정의
final detailPageViewModelProvider =
    NotifierProvider<DetailPageViewModel, DetailPageState>(
      () => DetailPageViewModel(),
    );
