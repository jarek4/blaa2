import 'package:blaa/ui/screens/home_screen/widgets/slide1_banner/slide1_banner.dart';
import 'package:blaa/ui/screens/home_screen/widgets/slide1_text_info/slide1_text_info.dart';
import 'package:blaa/ui/screens/home_screen/widgets/slide2_banner/slide2_banner.dart';
import 'package:blaa/ui/screens/home_screen/widgets/slide2_text_info/slide2_text_info.dart';
import 'package:blaa/ui/screens/home_screen/widgets/slides_indicator/slides_indicator.dart';
import 'package:blaa/ui/screens/home_screen/widgets/wrappers/narrow_home.dart';
import 'package:blaa/ui/screens/home_screen/widgets/wrappers/wide_home.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  static final _pageViewController = PageController();

  final List<Widget> _wideSlides = [
    const WideHomeSlideWrapper(
        banner: Slide1Banner(), textInfo: Slide1TextInfo()),
    const WideHomeSlideWrapper(
        banner: Slide2Banner(), textInfo: Slide2TextInfo())
  ];
  final List<Widget> _narrowedSlides = [
    const NarrowHomeSlideWrapper(
        banner: Slide1Banner(), textInfo: Slide1TextInfo()),
    const NarrowHomeSlideWrapper(
        banner: Slide2Banner(), textInfo: Slide2TextInfo())
  ];

  // ------------
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      final double maxWidth = viewportConstraints.maxWidth;
      // final double _maxHeight = viewportConstraints.maxHeight;
      final Orientation orientation = MediaQuery.of(context).orientation;
      const Orientation landscape = Orientation.landscape;
      return Stack(
        children: [
          PageView.builder(
              controller: _pageViewController,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                if (maxWidth < 800 && orientation != landscape) {
                  return _narrowedSlides[index];
                } else if (maxWidth > 600 && orientation == landscape) {
                  return _wideSlides[index];
                } else {
                  return _narrowedSlides[index];
                }
              }),
          const Align(
            alignment: Alignment.bottomCenter,
            child: SlidesIndicator(slidesNumber: 2),
          )
        ],
      );
    });
  }
}

/*
return SafeArea(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        final double _maxWidth = viewportConstraints.maxWidth;
        // final double _maxHeight = viewportConstraints.maxHeight;
        final Orientation _orientation = MediaQuery.of(context).orientation;
        if (_maxWidth < 800 && _orientation != Orientation.landscape) {
          return NarrowLayout(slides: _narrowedSlides);
        } else if (_maxWidth > 600 && _orientation == Orientation.landscape) {
          return WideLayout(slides: _wideSlides);
        } else {
          return NarrowLayout(slides: _narrowedSlides);
        }
      }),
    );
 */
