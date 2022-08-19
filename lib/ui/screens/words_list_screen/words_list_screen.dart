import 'package:blaa/ui/screens/words_list_screen/layouts/words_list_screen_layouts.dart';
import 'package:flutter/material.dart';

class WordsListScreen extends StatelessWidget {
  const WordsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final String _search =
    //     '${AppLocalizations.of(context)?.wordsListSearch}...';
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      final double _maxWidth = viewportConstraints.maxWidth;
      // final double _maxHeight = viewportConstraints.maxHeight;
      final Orientation _orientation = MediaQuery.of(context).orientation;
      const Orientation _landscape = Orientation.landscape;
      if (_maxWidth < 800 && _orientation != _landscape) {
        return const NarrowedLayout();
      } else if (_maxWidth > 600 && _orientation == _landscape) {
        return const WidenedLayout();
      } else {
        return const NarrowedLayout();
      }
    });
  }
}
