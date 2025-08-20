import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

class BoxOfficeSection extends StatelessWidget {
  const BoxOfficeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('흥행 정보', style: AppTheme.titleStyle),
        SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              InfoCard(value: '6.949', label: '평점'),
              InfoCard(value: '331', label: '평점투표수'),
              InfoCard(value: '5466.535', label: '인기점수'),
              InfoCard(value: '\$150000000', label: '예산'),
              InfoCard(value: '\$150000000', label: '수익'),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String value;
  final String label;

  const InfoCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [Text(value), Text(label)],
        ),
      ),
    );
  }
}
