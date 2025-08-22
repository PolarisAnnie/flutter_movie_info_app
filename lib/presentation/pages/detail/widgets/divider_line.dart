import 'package:flutter/material.dart';

// 섹션을 나누는 선 위젯
class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: Colors.grey[300], thickness: 0.3, height: 0.3);
  }
}
