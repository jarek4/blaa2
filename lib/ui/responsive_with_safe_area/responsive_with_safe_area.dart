import 'package:flutter/material.dart';

typedef ResponsiveBuilder = Widget Function(
    BuildContext context,
    BoxConstraints dimens,
    Size size,
    );

class ResponsiveWithSafeArea extends StatelessWidget {
  const ResponsiveWithSafeArea({
    required ResponsiveBuilder builder,
    Key? key,
  })  : responsiveBuilder = builder,
        super(key: key);

  final ResponsiveBuilder responsiveBuilder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return responsiveBuilder(
            context,
            constraints,
            constraints.biggest,
          );
        },
      ),
    );
  }
}