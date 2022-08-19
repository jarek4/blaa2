import 'package:flutter/material.dart';

class WideHomeSlideWrapper extends StatelessWidget {
  const WideHomeSlideWrapper({
    Key? key,
    required this.banner,
    required this.textInfo,
  }) : super(key: key);

  final Widget banner;
  final Widget textInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: banner),
        Expanded(
          flex: 3,
          child: textInfo,
        )
      ],
    );
  }
}
