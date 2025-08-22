import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

// 영화의 흥행 정보를 표시하는 섹션
// 평점, 투표수, 예산, 수익 데이터를 보여줌
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
        // '흥행 정보' 제목 표시
        Text('흥행 정보', style: AppTheme.titleStyle),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          // 가로 스크롤이 가능한 리스트뷰로 여러 정보 카드 나열
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // 평점을 소수점 첫째 자리까지 표시
              InfoCard(value: voteAverage.toStringAsFixed(1), label: '평점'),
              // 투표수를 포맷팅하여 'K'(천), 'M'(백만) 단위로 표시
              InfoCard(value: _formatNumber(voteCount), label: '평점투표수'),
              // 인기점수를 소수점 첫째 자리까지 표시
              InfoCard(value: popularity.toStringAsFixed(1), label: '인기점수'),
              // 예산을 통화 형식으로 포맷팅하여 표시
              InfoCard(value: _formatCurrency(budget), label: '예산'),
              // 수익을 통화 형식으로 포맷팅하여 표시
              InfoCard(value: _formatCurrency(revenue), label: '수익'),
            ],
          ),
        ),
      ],
    );
  }

  // 숫자를 K(천) 또는 M(백만) 단위로 포맷팅하는 private 메서드
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // 금액을 K, M, B(십억) 단위로 포맷팅하고 통화 기호를 붙이는 private 메서드
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

// 단일 정보 항목(값과 라벨)을 표시하는 카드 형태의 위젯
class InfoCard extends StatelessWidget {
  final String value;
  final String label;

  const InfoCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
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
