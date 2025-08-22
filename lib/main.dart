import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_movie_info_app/presentation/pages/home/home_page.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movie_info_app/data/data_source/movie_data_source_impl.dart';
import 'package:http/http.dart' as http;

// API 토큰을 외부에서 주입하기 위한 provider
final accessTokenProvider = Provider<String>((ref) {
  // main 함수에서 로드한 accessToken을 주입
  final accessToken = dotenv.env['TMDB_ACCESS_TOKEN'];
  if (accessToken == null) {
    throw Exception("TMDB_ACCESS_TOKEN not found in .env file");
  }
  return accessToken;
});

// http 클라이언트를 위한 provider
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// MovieDataSource를 위한 provider
final movieDataSourceProvider = Provider<MovieDataSourceImpl>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final accessToken = ref.watch(accessTokenProvider);
  return MovieDataSourceImpl(httpClient: httpClient, accessToken: accessToken);
});

void main() async {
  // 앱 실행 전에 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 로드
  await dotenv.load(fileName: ".env");

  runApp(
    // ProviderScope로 앱 전체에 Riverpod Provider를 사용 가능하도록
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
