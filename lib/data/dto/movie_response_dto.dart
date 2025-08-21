// {
//   "dates": {
//     "maximum": "2025-08-27",
//     "minimum": "2025-07-16"
//   },
//   "page": 1,
//   "results": [
//     {
//       "adult": false,
//       "backdrop_path": "/1RgPyOhN4DRs225BGTlHJqCudII.jpg",
//       "genre_ids": [
//         16,
//         28,
//         14,
//         53
//       ],
//       "id": 1311031,
//       "original_language": "ja",
//       "original_title": "劇場版「鬼滅の刃」無限城編 第一章 猗窩座再来",
//       "overview": "혈귀로 변해버린 여동생 네즈코를 인간으로 되돌리기 위해 혈귀를 사냥하는 조직인 《귀살대》에 입대한 카마도 탄지로. 입대 후 동료인 아가츠마 젠이츠, 하시비라 이노스케와 함께 많은 혈귀와 싸우고, 성장하면서 세 사람의 우정과 유대는 깊어진다. 탄지로는 《귀살대》 최고위 검사인 《주》와도 함께 싸웠다. 「무한열차」에서는 염주・렌고쿠 쿄쥬로, 「유곽」에서는 음주・우즈이 텐겐, 「도공 마을」에서는 하주・토키토 무이치로, 연주・칸로지 미츠리와 함께 혈귀를 상대로 격렬한 전투를 벌였다. 그 후 다가올 혈귀와의 결전에 대비해 귀살대원들과 함께 《주》가 주도하는 합동 강화 훈련에 참가해 훈련을 받던 도중 《귀살대》의 본부인 우부야시키 저택에 나타난 키부츠지 무잔. 어르신의 위기에 달려온 《주》들과 탄지로였지만, 무잔의 술수로 의문의 공간으로 떨어지고 말았는데. 탄지로 일행이 떨어진 곳, 그곳은 혈귀의 본거지 《무한성》─ “귀살대”와 “혈귀”의 최종 결전의 포문이 열린다.",
//       "popularity": 307.6385,
//       "poster_path": "/m6Dho6hDCcL5KI8mOQNemZAedFI.jpg",
//       "release_date": "2025-08-22",
//       "title": "극장판 귀멸의 칼날: 무한성편",
//       "video": false,
//       "vote_average": 7.2,
//       "vote_count": 79
//     },
//  ],
//   "total_pages": 5,
//   "total_results": 90
// }

class MovieResponseDto {
  final Dates? dates;
  final int page;
  final List<Result> results;
  final int? totalPages;
  final int? totalResults;

  MovieResponseDto({
    this.dates,
    required this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MovieResponseDto.fromJson(Map<String, dynamic> json) {
    return MovieResponseDto(
      dates: json['dates'] != null ? Dates.fromJson(json['dates']) : null,
      page: json['page'] ?? 1,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => Result.fromJson(e))
              .toList() ??
          [],
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dates': dates?.toJson(),
      'page': page,
      'results': results.map((e) => e.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}

class Dates {
  final DateTime? maximum;
  final DateTime? minimum;

  Dates({this.maximum, this.minimum});

  factory Dates.fromJson(Map<String, dynamic> json) {
    return Dates(
      maximum: json['maximum'] != null && json['maximum'].isNotEmpty
          ? DateTime.tryParse(json['maximum'])
          : null,
      minimum: json['minimum'] != null && json['minimum'].isNotEmpty
          ? DateTime.tryParse(json['minimum'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maximum': maximum?.toIso8601String().split('T')[0],
      'minimum': minimum?.toIso8601String().split('T')[0],
    };
  }
}

class Result {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final DateTime? releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Result({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'],
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      id: json['id'] ?? 0,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      posterPath: json['poster_path'],
      releaseDate:
          json['release_date'] != null && json['release_date'].isNotEmpty
          ? DateTime.tryParse(json['release_date'])
          : null,
      title: json['title'] ?? '',
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'id': id,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'release_date': releaseDate?.toIso8601String().split('T')[0],
      'title': title,
      'video': video,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }
}
