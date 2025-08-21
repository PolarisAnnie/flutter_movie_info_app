import 'dart:convert';

import 'package:flutter_movie_info_app/data/data_source/movie_data_source.dart';
import 'package:flutter_movie_info_app/data/dto/movie_detail_dto.dart';
import 'package:flutter_movie_info_app/data/dto/movie_response_dto.dart';
import 'package:http/http.dart' as http;

class MovieDataSourceImpl implements MovieDataSource {
  final String _apiKey = const String.fromEnvironment('TMDB_ACCESS_TOKEN');
  final String _baseUrl = 'https://api.themoviedb.org/3';

  @override
  Future<MovieResponseDto?> fetchNowPlayingMovies() async {
    try {
      final url = '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=ko-KR';
      final response = await http.get(Uri.parse(url));

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
  Future<MovieResponseDto?> fetchPopularMovies() async {
    try {
      final url = '$_baseUrl/movie/popular?api_key=$_apiKey&language=ko-KR';
      final response = await http.get(Uri.parse(url));

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
      final url = '$_baseUrl/movie/top_rated?api_key=$_apiKey&language=ko-KR';
      final response = await http.get(Uri.parse(url));

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
      final url = '$_baseUrl/movie/upcoming?api_key=$_apiKey&language=ko-KR';
      final response = await http.get(Uri.parse(url));

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
      final url = '$_baseUrl/movie/$id?api_key=$_apiKey&language=ko-KR';
      final response = await http.get(Uri.parse(url));

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
