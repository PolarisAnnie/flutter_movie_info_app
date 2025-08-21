import 'dart:convert';
import 'package:flutter_movie_info_app/data/dto/movie_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MovieResponseDto: fromJson 테스트', () {
    const sampleJsonString = """
    {
      "dates": {
        "maximum": "2025-08-27",
        "minimum": "2025-07-16"
      },
      "page": 1,
      "results": [
        {
          "adult": false,
          "backdrop_path": "/1RgPyOhN4DRs225BGTlHJqCudII.jpg",
          "genre_ids": [16, 28, 14, 53],
          "id": 1311031,
          "original_language": "ja",
          "original_title": "劇場版「鬼滅の刃」無限城編 第一章 猗窩座再来",
          "overview": "혈귀로 변해버린 여동생 네즈코를 인간으로 되돌리기 위해...",
          "popularity": 307.6385,
          "poster_path": "/m6Dho6hDCcL5KI8mOQNemZAedFI.jpg",
          "release_date": "2025-08-22",
          "title": "극장판 귀멸의 칼날: 무한성편",
          "video": false,
          "vote_average": 7.2,
          "vote_count": 79
        }
      ],
      "total_pages": 47,
      "total_results": 940
    }
    """;

    final movieResponse = MovieResponseDto.fromJson(
      jsonDecode(sampleJsonString),
    );

    expect(movieResponse.page, 1);
    expect(movieResponse.totalPages, 47);
    expect(movieResponse.totalResults, 940);

    // Dates 테스트
    expect(movieResponse.dates, isNotNull);
    expect(movieResponse.dates!.maximum, DateTime(2025, 8, 27));
    expect(movieResponse.dates!.minimum, DateTime(2025, 7, 16));

    // Results 테스트
    expect(movieResponse.results.length, 1);
    final firstMovie = movieResponse.results[0];

    expect(firstMovie.adult, false);
    expect(firstMovie.backdropPath, "/1RgPyOhN4DRs225BGTlHJqCudII.jpg");
    expect(firstMovie.genreIds, [16, 28, 14, 53]);
    expect(firstMovie.id, 1311031);
    expect(firstMovie.originalLanguage, "ja");
    expect(firstMovie.originalTitle, "劇場版「鬼滅の刃」無限城編 第一章 猗窩座再来");
    expect(firstMovie.overview, "혈귀로 변해버린 여동생 네즈코를 인간으로 되돌리기 위해...");
    expect(firstMovie.popularity, 307.6385);
    expect(firstMovie.posterPath, "/m6Dho6hDCcL5KI8mOQNemZAedFI.jpg");
    expect(firstMovie.releaseDate, DateTime(2025, 8, 22));
    expect(firstMovie.title, "극장판 귀멸의 칼날: 무한성편");
    expect(firstMovie.video, false);
    expect(firstMovie.voteAverage, 7.2);
    expect(firstMovie.voteCount, 79);
  });

  test('MovieResponseDto: date 없을 때 테스트', () {
    const sampleJsonString = """
    {
      "page": 2,
      "results": [],
      "total_pages": 100,
      "total_results": 2000
    }
    """;

    final movieResponse = MovieResponseDto.fromJson(
      jsonDecode(sampleJsonString),
    );

    expect(movieResponse.page, 2);
    expect(movieResponse.totalPages, 100);
    expect(movieResponse.totalResults, 2000);
    expect(movieResponse.dates, isNull);
    expect(movieResponse.results, isEmpty);
  });

  test('MovieResponseDto: 결과 비어있을 때 테스트', () {
    const sampleJsonString = """
    {
      "page": 1,
      "results": [],
      "total_pages": 0,
      "total_results": 0
    }
    """;

    final movieResponse = MovieResponseDto.fromJson(
      jsonDecode(sampleJsonString),
    );

    expect(movieResponse.page, 1);
    expect(movieResponse.totalPages, 0);
    expect(movieResponse.totalResults, 0);
    expect(movieResponse.results, isEmpty);
  });
}
