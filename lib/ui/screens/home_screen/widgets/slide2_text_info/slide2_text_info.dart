import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Slide2TextInfo extends StatelessWidget {
  const Slide2TextInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // const Expanded(child: SizedBox()),
          Expanded(
            flex: 2,

            child: Text(
                '${AppLocalizations.of(context)?.slide2DemoMode}\n${AppLocalizations.of(context)?.slide2UseAllFunctionality}',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    letterSpacing: 1.2,
                    fontSize: 16.0,
                    height: 1.3),
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('${AppLocalizations.of(context)?.slide2SignIn}',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    letterSpacing: 1.2,
                    fontSize: 16.0,
                    height: 1.3),
                textAlign: TextAlign.center),
          ),
          // const Expanded(child: SizedBox())
        ],
      ),
    );
  }
}
