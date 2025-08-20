import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/presentation/pages/detail/detail_page.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

class MovieList extends StatelessWidget {
  final String label;
  final bool orderByPopular;
  const MovieList({
    required this.label,
    required this.orderByPopular,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.titleStyle),
        SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.builder(
            itemCount: 20,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Padding(
                    padding: orderByPopular
                        ? const EdgeInsets.only(right: 24)
                        : const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        //TODO: 영화 정보 가지고 넘기기
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(heroTag: 'movie-$label-$index'),
                          ),
                        );
                      },
                      child: orderByPopular
                          ? Stack(
                              clipBehavior: Clip.none, // 영역 밖으로 나가도 보이게
                              children: [
                                Hero(
                                  tag: 'movie-$label-$index',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    //TODO: TMDB API에서 이미지 정보 넣기
                                    child: Image.network(
                                      'https://picsum.photos/500/700', // 고정 크기
                                      width: 120,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -10,
                                  left: -20,
                                  child: Text(
                                    '${index + 1}',
                                    style: AppTheme.headerStyle,
                                  ),
                                ),
                              ],
                            )
                          : Hero(
                              tag: 'movie-$label-$index',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                //TODO: TMDB API에서 이미지 정보 넣기
                                child: Image.network(
                                  'https://picsum.photos/500/700',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
