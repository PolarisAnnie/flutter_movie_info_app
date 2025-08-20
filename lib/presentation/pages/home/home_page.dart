import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/detail_page.dart';
import 'package:flutter_movie_info_app/presentation/pages/home/widgets/movie_list.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
      child: Scaffold(
        body: ListView(
          children: [
            Text('가장 인기있는', style: AppTheme.titleStyle),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                //TODO: 영화 정보 가지고 넘기기
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailPage()),
                );
              },
              child: SizedBox(
                height: 500,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://picsum.photos/500/700',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 18),
            MovieList(label: '현재 상영 중', orderByPopular: false),
            SizedBox(height: 18),
            MovieList(label: '인기순', orderByPopular: true),
            SizedBox(height: 18),
            MovieList(label: '평점 높은 순', orderByPopular: false),
            SizedBox(height: 18),
            MovieList(label: '개봉 예정', orderByPopular: false),
          ],
        ),
      ),
    );
  }
}
