import 'package:blaa/utils/constants/assets_const.dart';
import 'package:flutter/material.dart';

class Slide1Banner extends StatelessWidget {
  const Slide1Banner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(AssetsConst.welcome['path']!,
        fit: BoxFit.scaleDown, alignment: Alignment.topCenter);
  }
}
