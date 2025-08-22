import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

// 장르 목록을 가로로 스크롤하여 표시
class GenreList extends StatelessWidget {
  final List<String> genres;

  const GenreList({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    // 위젯 높이 35로 고정
    return SizedBox(
      height: 35,
      // 장르 목록 효율적 렌더링
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 가로 스크롤 방향
        itemCount: genres.length, // 리스트 항목 수
        itemBuilder: (context, index) {
          // 각 항목에 패딩 적용
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: GenreChip(genre: genres[index]),
          );
        },
      ),
    );
  }
}

// 단일 장르 칩 위젯
class GenreChip extends StatelessWidget {
  final String genre;

  const GenreChip({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          genre,
          style: AppTheme.bodyStyle.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
