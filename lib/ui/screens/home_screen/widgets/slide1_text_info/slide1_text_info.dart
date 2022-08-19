import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Slide1TextInfo extends StatelessWidget {
  const Slide1TextInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Text('${AppLocalizations.of(context)?.slide1Start} 🎉',
              style: const TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w300,
                  color: Color(0XFF3F3D56),
                  height: 1.0)),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Text(
              '${AppLocalizations.of(context)?.slide1LearnFaster}\n${AppLocalizations.of(context)?.slide1StoreWords}',
              style: const TextStyle(
                  color: Colors.grey,
                  letterSpacing: 1.2,
                  fontSize: 16.0,
                  height: 1.3),
              textAlign: TextAlign.center),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                  '${AppLocalizations.of(context)?.slide1LearningProject}.\n${AppLocalizations.of(context)?.slide1ForFun}',
                  style: const TextStyle(
                      color: Colors.grey,
                      letterSpacing: 1.2,
                      fontSize: 14.0,
                      height: 1.1),
                  textAlign: TextAlign.center)),
        ),
        // const Expanded(flex: 1,child: SizedBox())
      ]),
    );
  }
}
