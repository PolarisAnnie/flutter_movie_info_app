import 'dart:convert';
import 'package:flutter_movie_info_app/data/dto/movie_detail_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MovieDetailDto: fromJson 태스트', () {
    const sampleJsonString = """
    {
      "adult": false,
      "backdrop_path": "/zNriRTr0kWwyaXPzdg1EIxf0BWk.jpg",
      "belongs_to_collection": {
        "id": 328,
        "name": "쥬라기 공원 시리즈",
        "poster_path": "/qIm2nHXLpBBdMxi8dvfrnDkBUDh.jpg",
        "backdrop_path": "/njFixYzIxX8jsn6KMSEtAzi4avi.jpg"
      },
      "budget": 180000000,
      "genres": [
        {
          "id": 878,
          "name": "SF"
        },
        {
          "id": 12,
          "name": "모험"
        }
      ],
      "homepage": "",
      "id": 1234821,
      "imdb_id": "tt31036941",
      "origin_country": ["US"],
      "original_language": "en",
      "original_title": "Jurassic World Rebirth",
      "overview": "지구 최상위 포식자가 된 공룡들이 인간 세상으로 나온 5년 후...",
      "popularity": 509.6217,
      "poster_path": "/ygr4hE8Qpagv8sxZbMw1mtYkcQE.jpg",
      "production_companies": [
        {
          "id": 33,
          "logo_path": "/6exxhPonOo0M995SAchY0ijpRao.png",
          "name": "Universal Pictures",
          "origin_country": "US"
        }
      ],
      "production_countries": [
        {
          "iso_3166_1": "US",
          "name": "United States of America"
        }
      ],
      "release_date": "2025-07-01",
      "revenue": 829115670,
      "runtime": 134,
      "spoken_languages": [
        {
          "english_name": "English",
          "iso_639_1": "en",
          "name": "English"
        }
      ],
      "status": "Released",
      "tagline": "가장 위험한 놈들만 여기 남겨진 거야",
      "title": "쥬라기 월드: 새로운 시작",
      "video": false,
      "vote_average": 6.382,
      "vote_count": 1677
    }
    """;

    final movieDetail = MovieDetailDto.fromJson(jsonDecode(sampleJsonString));

    expect(movieDetail.adult, false);
    expect(movieDetail.backdropPath, "/zNriRTr0kWwyaXPzdg1EIxf0BWk.jpg");
    expect(movieDetail.budget, 180000000);
    expect(movieDetail.id, 1234821);
    expect(movieDetail.imdbId, "tt31036941");
    expect(movieDetail.originalLanguage, "en");
    expect(movieDetail.originalTitle, "Jurassic World Rebirth");
    expect(movieDetail.overview, "지구 최상위 포식자가 된 공룡들이 인간 세상으로 나온 5년 후...");
    expect(movieDetail.popularity, 509.6217);
    expect(movieDetail.posterPath, "/ygr4hE8Qpagv8sxZbMw1mtYkcQE.jpg");
    expect(movieDetail.revenue, 829115670);
    expect(movieDetail.runtime, 134);
    expect(movieDetail.status, "Released");
    expect(movieDetail.tagline, "가장 위험한 놈들만 여기 남겨진 거야");
    expect(movieDetail.title, "쥬라기 월드: 새로운 시작");
    expect(movieDetail.video, false);
    expect(movieDetail.voteAverage, 6.382);
    expect(movieDetail.voteCount, 1677);
    expect(movieDetail.releaseDate, DateTime(2025, 7, 1));
    expect(movieDetail.originCountry, ["US"]);

    // 중첩 객체 테스트
    expect(movieDetail.belongsToCollection, isNotNull);
    expect(movieDetail.belongsToCollection!.id, 328);
    expect(movieDetail.belongsToCollection!.name, "쥬라기 공원 시리즈");

    expect(movieDetail.genres.length, 2);
    expect(movieDetail.genres[0].id, 878);
    expect(movieDetail.genres[0].name, "SF");
    expect(movieDetail.genres[1].id, 12);
    expect(movieDetail.genres[1].name, "모험");

    expect(movieDetail.productionCompanies.length, 1);
    expect(movieDetail.productionCompanies[0].id, 33);
    expect(movieDetail.productionCompanies[0].name, "Universal Pictures");
    expect(
      movieDetail.productionCompanies[0].logoPath,
      "/6exxhPonOo0M995SAchY0ijpRao.png",
    );

    expect(movieDetail.productionCountries.length, 1);
    expect(movieDetail.productionCountries[0].iso31661, "US");
    expect(movieDetail.productionCountries[0].name, "United States of America");

    expect(movieDetail.spokenLanguages.length, 1);
    expect(movieDetail.spokenLanguages[0].englishName, "English");
    expect(movieDetail.spokenLanguages[0].iso6391, "en");
    expect(movieDetail.spokenLanguages[0].name, "English");
  });

  test('MovieDetailDto: null일 때 결과값 테스트', () {
    const sampleJsonString = """
    {
      "adult": false,
      "backdrop_path": null,
      "belongs_to_collection": null,
      "budget": 0,
      "genres": [],
      "homepage": "",
      "id": 123,
      "imdb_id": null,
      "origin_country": [],
      "original_language": "en",
      "original_title": "Test Movie",
      "overview": "",
      "popularity": 0.0,
      "poster_path": null,
      "production_companies": [],
      "production_countries": [],
      "release_date": "",
      "revenue": 0,
      "runtime": 0,
      "spoken_languages": [],
      "status": "",
      "tagline": "",
      "title": "Test Movie",
      "video": false,
      "vote_average": 0.0,
      "vote_count": 0
    }
    """;

    final movieDetail = MovieDetailDto.fromJson(jsonDecode(sampleJsonString));

    expect(movieDetail.backdropPath, isNull);
    expect(movieDetail.belongsToCollection, isNull);
    expect(movieDetail.imdbId, isNull);
    expect(movieDetail.posterPath, isNull);
    expect(movieDetail.releaseDate, isNull);
    expect(movieDetail.genres, isEmpty);
    expect(movieDetail.productionCompanies, isEmpty);
    expect(movieDetail.productionCountries, isEmpty);
    expect(movieDetail.spokenLanguages, isEmpty);
    expect(movieDetail.originCountry, isEmpty);
  });
}
