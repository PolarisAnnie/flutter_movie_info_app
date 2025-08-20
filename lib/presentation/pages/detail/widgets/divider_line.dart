import 'package:flutter/material.dart';

class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: Colors.grey[300], thickness: 0.3, height: 0.3);
  }
}
