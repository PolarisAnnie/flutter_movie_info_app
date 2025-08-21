// lib/data/data_source/movie_data_source_impl.dart
import 'dart:convert';
import 'package:flutter_movie_info_app/data/data_source/movie_data_source.dart';
import 'package:flutter_movie_info_app/data/dto/movie_detail_dto.dart';
import 'package:flutter_movie_info_app/data/dto/movie_response_dto.dart';
import 'package:http/http.dart' as http;

class MovieDataSourceImpl implements MovieDataSource {
  final http.Client httpClient;
  final String _accessToken;
  final String _baseUrl = 'https://api.themoviedb.org/3';

  // 생성자에서 httpClient와 accessToken 주입
  MovieDataSourceImpl({http.Client? httpClient, required String accessToken})
    : httpClient = httpClient ?? http.Client(),
      _accessToken = accessToken {}

  @override
  Future<MovieResponseDto?> fetchNowPlayingMovies() async {
    try {
      final url = '$_baseUrl/movie/now_playing?language=ko-KR';
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_accessToken', // _apiKey 대신 _accessToken 사용
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
