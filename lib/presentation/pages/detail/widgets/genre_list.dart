import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

class GenreList extends StatelessWidget {
  final List<String> genres;

  const GenreList({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: GenreChip(genre: genres[index]),
          );
        },
      ),
    );
  }
}

class GenreChip extends StatelessWidget {
  final String genre;

  const GenreChip({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
