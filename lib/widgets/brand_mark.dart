import 'package:flutter/material.dart';

/// The app icon: the colored card stack inside its own squircle.
/// No extra frame — another rounded rect would hide that silhouette.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 112});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Image.asset(
        'assets/icon/icon_squircle.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
