import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

class BoxOfficeSection extends StatelessWidget {
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final int budget;
  final int revenue;

  const BoxOfficeSection({
    super.key,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.budget,
    required this.revenue,
  });

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
              InfoCard(value: voteAverage.toStringAsFixed(1), label: '평점'),
              InfoCard(value: _formatNumber(voteCount), label: '평점투표수'),
              InfoCard(value: popularity.toStringAsFixed(1), label: '인기점수'),
              InfoCard(value: _formatCurrency(budget), label: '예산'),
              InfoCard(value: _formatCurrency(revenue), label: '수익'),
            ],
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatCurrency(int amount) {
    if (amount == 0) return '정보 없음';
    if (amount >= 1000000000) {
      return '\$${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '\$$amount';
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
