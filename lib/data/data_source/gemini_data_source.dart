import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// Gemini API를 사용하여 영화 리뷰를 분석하는 데이터 소스
class GeminiDataSource {
  late final GenerativeModel _model;

  // 생성자: GEMINI_API_KEY를 사용하여 모델 초기화
  GeminiDataSource() {
    final apiKey = dotenv.env['GEMINI_API_KEY']!;
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  // 영화 제목과 연도를 바탕으로 리뷰를 분석하고 한줄평을 생성
  Future<List<String>> analyzeMovieReviews(
    String movieTitle,
    int movieYear,
  ) async {
    // Gemini 모델에 전달할 프롬프트
    final prompt =
        '''
영화 "$movieTitle ($movieYear)"에 대한 온라인 리뷰들을 종합하여 분석해주세요.

다음 조건을 만족하는 3줄의 한줄평을 작성해주세요:
1. 각 줄은 서로 다른 관점 (스토리, 연출/영상, 연기/캐릭터)을 다뤄야 합니다
2. 실제 관객들의 반응을 반영해주세요
3. 긍정적/부정적 의견을 균형있게 포함해주세요
4. 각 줄은 "~다", "~음" 으로 자연스럽게 끝나야 합니다
5. 각 줄은 공백 포함 24자 이내로 작성합니다

출력 형식 (번호 없이):
스토리 관련 한줄평
연출/영상 관련 한줄평  
연기/캐릭터 관련 한줄평
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw Exception('Gemini 응답이 없습니다');
      }

      // 응답을 줄 단위로 분리하고 정리
      final lines = response.text!
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim())
          .take(3)
          .toList();

      // 3줄이 안 나오면 기본값 제공
      while (lines.length < 3) {
        lines.add('분석 중입니다...');
      }

      return lines;
    } catch (e) {
      print('Gemini API 오류: $e');
      return ['리뷰 분석 중 오류가 발생했습니다', '잠시 후 다시 시도해주세요', '네트워크 연결을 확인해주세요'];
    }
  }
}
