import 'package:flutter/material.dart';

class SlidesIndicator extends StatelessWidget {
  const SlidesIndicator({Key? key, required this.slidesNumber})
      : super(key: key);
  final int slidesNumber;
  static const double _currentPage = 0.0;

  List<Widget> _indicator() => List<Widget>.generate(
      slidesNumber,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: _currentPage.round() == index
                    ? const Color(0XFF256075)
                    : const Color(0XFF256075).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70.0),
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _indicator(),
      ),
    );
  }
}
