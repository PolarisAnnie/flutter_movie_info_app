import 'package:flutter/material.dart';

// 제작사 갤러리 가로 스크롤 표시
class ProductionGallery extends StatelessWidget {
  final List<String> productionImageUrls;
  final List<String> productionCompanyNames;

  const ProductionGallery({
    super.key,
    required this.productionImageUrls,
    required this.productionCompanyNames,
  });

  @override
  Widget build(BuildContext context) {
    // 위젯 높이 80으로 고정
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 가로 스크롤 방향
        itemCount: productionImageUrls.length, // 리스트 항목 수
        itemBuilder: (context, index) {
          // 각 항목에 패딩 적용
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ProductionImage(
              imageUrl: productionImageUrls[index],
              companyName: productionCompanyNames[index],
            ),
          );
        },
      ),
    );
  }
}

// 단일 제작사 이미지
class ProductionImage extends StatelessWidget {
  final String imageUrl;
  final String companyName;

  const ProductionImage({
    super.key,
    required this.imageUrl,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        // 배경 투명도 처리
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        // 네트워크 이미지 로드
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          width: 120,
          height: 80,
          // 이미지 로딩 시 로딩 인디케이터 표시
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 120,
              height: 80,
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          // 이미지 로드 실패 시 대체 위젯 표시
          errorBuilder: (context, error, stackTrace) {
            return Container(
              alignment: Alignment.center,
              width: 120,
              height: 80,
              color: Colors.grey[300],
              child: Text(
                companyName, // 회사 이름 텍스트 표시
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ),
      ),
    );
  }
}
