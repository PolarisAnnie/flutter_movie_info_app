import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

class MovieInfoSection extends StatelessWidget {
  final String title;
  final String releaseDate;
  final String tagline;
  final String runtime;

  const MovieInfoSection({
    super.key,
    required this.title,
    required this.releaseDate,
    required this.tagline,
    required this.runtime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목과 개봉일
        Row(
          children: [
            Expanded(child: Text(title, style: AppTheme.titleStyle)),
            Text(releaseDate, style: AppTheme.bodyStyle),
          ],
        ),
        // 태그라인이 있을 경우에만 해당 섹션 보여주기
        if (tagline.isNotEmpty) ...[
          SizedBox(height: 12),
          // 태그라인
          Text(tagline, style: AppTheme.bodyStyle, maxLines: 3),
        ],

        SizedBox(height: 4),

        // 러닝타임
        Text(runtime, style: AppTheme.bodyStyle),
      ],
    );
  }
}
