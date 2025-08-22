import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/data/data_source/gemini_data_source.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

// Gemini API를 이용한 영화 리뷰 분석 섹션 위젯
class ReviewSection extends StatefulWidget {
  final String movieTitle; // 영화 제목
  final int movieYear; // 개봉 연도

  const ReviewSection({
    required this.movieTitle,
    this.movieYear = 0,
    super.key,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  List<String>? _reviewLines;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyzeReviews(); // 위젯 초기화 시 리뷰 분석 시작
  }

  // Gemini API를 호출하여 리뷰를 분석
  Future<void> _analyzeReviews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final geminiService = GeminiDataSource();
      final reviews = await geminiService.analyzeMovieReviews(
        widget.movieTitle,
        widget.movieYear,
      );

      setState(() {
        _reviewLines = reviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'AI 분석 중 오류가 발생했습니다';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('🤖 AI 리뷰 분석', style: AppTheme.titleStyle), // 제목 표시
            if (_isLoading) ...[
              const SizedBox(width: 8),
              // 로딩 중일 때 작은 인디케이터 표시
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 120, // 최소 높이
            maxHeight: 300, // 최대 높이
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withAlpha(220),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: _buildContent(), // 로딩, 에러, 결과에 따라 다른 위젯 표시
          ),
        ),
      ],
    );
  }

  // 상태에 따른 콘텐츠 위젯 빌드
  Widget _buildContent() {
    // 로딩 중일 때 로딩 위젯 표시
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.black54,
              strokeWidth: 3,
            ),
            const SizedBox(height: 12),
            Text(
              'AI가 "${widget.movieTitle}" 리뷰를 분석 중...',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // 에러 발생 시 에러 위젯 표시
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 28),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Colors.red[700], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // 리뷰 결과가 없을 때 메시지 표시
    if (_reviewLines == null || _reviewLines!.isEmpty) {
      return const Center(
        child: Text('리뷰 분석 결과가 없습니다', style: TextStyle(color: Colors.black54)),
      );
    }

    // 성공적으로 리뷰를 받아왔을 때 결과 표시
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: _reviewLines!
          .map(
            (review) => Flexible(
              child: Text(
                '✔️ $review',
                style: const TextStyle(
                  color: Colors.black87,
                  height: 1.3,
                  fontSize: 13,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
