import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReadSVG {
  static Widget read(String asset, {Color? color, double? size}) {
    return Center(
      child: asset.isEmpty
          ? const Center()
          : SvgPicture.asset(
              'assets/$asset.svg',
              color: color ?? Colors.white,
              height: size ?? 20,
              width: size ?? 20,
            ),
    );
  }
}
