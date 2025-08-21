import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/box_office_section.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/divider_line.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/genre_list.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/movie_info_section.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/widgets/production_gallery.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.heroTag});

  final String heroTag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              width: double.infinity,
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  //TODO: TMDB API에서 이미지 정보 넣기
                  child: Image.network(
                    'https://picsum.photos/500/700',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MovieInfoSection(
                    title: 'Avengers: Endgame',
                    releaseDate: '2019-04-26',
                    overview: 'After the devastating events of Infinity War',
                    runtime: '181분',
                  ),
                  SizedBox(height: 8),
                  DividerLine(),
                  SizedBox(height: 8),
                  GenreList(
                    genres: ['Animation', 'Adventure', 'Family', 'Comedy'],
                  ),
                  SizedBox(height: 8),
                  DividerLine(),
                  SizedBox(height: 8),
                  Text('description' * 20, style: AppTheme.bodyStyle),
                  SizedBox(height: 8),
                  DividerLine(),
                  SizedBox(height: 20),
                  BoxOfficeSection(),
                  SizedBox(height: 12),
                  ProductionGallery(
                    productionImageUrls: [
                      'https://picsum.photos/80/40',
                      'https://picsum.photos/50/50',
                      'https://picsum.photos/30/30',
                      'https://picsum.photos/80/40',
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
