import 'package:flutter/material.dart';

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
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productionImageUrls.length,
        itemBuilder: (context, index) {
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
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          width: 120,
          height: 80,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 120,
              height: 80,
              color: Colors.grey[300],
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              alignment: Alignment.center,
              width: 120,
              height: 80,
              color: Colors.grey[300],
              child: Text(
                companyName,
                style: TextStyle(
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
