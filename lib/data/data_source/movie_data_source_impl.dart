import 'dart:convert';
import 'package:flutter_movie_info_app/data/data_source/movie_data_source.dart';
import 'package:flutter_movie_info_app/data/dto/movie_detail_dto.dart';
import 'package:flutter_movie_info_app/data/dto/movie_response_dto.dart';
import 'package:http/http.dart' as http;

// API에서 영화 데이터를 가져오는 클래스
class MovieDataSourceImpl implements MovieDataSource {
  final http.Client httpClient;
  final String _accessToken;
  final String _baseUrl = 'https://api.themoviedb.org/3';

  // 생성자로 HTTP 클라이언트와 액세스 토큰 주입
  MovieDataSourceImpl({http.Client? httpClient, required String accessToken})
    : httpClient = httpClient ?? http.Client(),
      _accessToken = accessToken;

  // 지금 상영 중인 영화 목록 가져오기
  @override
  Future<MovieResponseDto?> fetchNowPlayingMovies() async {
    try {
      final url = '$_baseUrl/movie/now_playing?language=ko-KR';
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_accessToken', // 인증 헤더
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieResponseDto.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print('Error:  $e');
      return null;
    }
  }

  // 인기 영화 목록 가져오기
  @override
  Future<MovieResponseDto?> fetchPopularMovies() async {
    try {
      final url = '$_baseUrl/movie/popular?language=ko-KR';
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieResponseDto.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // 평점 높은 영화 목록 가져오기
  @override
  Future<MovieResponseDto?> fetchTopRatedMovies() async {
    try {
      final url = '$_baseUrl/movie/top_rated?language=ko-KR';
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieResponseDto.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // 개봉 예정 영화 목록 가져오기
  @override
  Future<MovieResponseDto?> fetchUpcomingMovies() async {
    try {
      final url = '$_baseUrl/movie/upcoming?language=ko-KR';
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieResponseDto.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // 영화 상세 정보 가져오기
  @override
  Future<MovieDetailDto?> fetchMovieDetail(int id) async {
    try {
      final url = '$_baseUrl/movie/$id?language=ko-KR';
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieDetailDto.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
