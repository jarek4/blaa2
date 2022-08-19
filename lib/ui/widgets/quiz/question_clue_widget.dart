import 'package:blaa/ui/widgets/quiz/clue/expandable_list_tile.dart';
import 'package:flutter/material.dart';


class QuestionClueWidget extends StatelessWidget {
  const QuestionClueWidget({
    Key? key,
    required this.clue,
    required this.isExpended,
    required this.onChanged,
  }) : super(key: key);

  final String? clue;
  final bool isExpended;
  //final ValueChanged<bool> onChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return ExpandableListTile(
      onExpandPressed: () => onChanged(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Clue',
                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                textAlign: TextAlign.start),
            Text('takes 2 points',
                style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w600),
                textAlign: TextAlign.start),
          ],
        ),
        expanded: isExpended,
      child: Center(
        child: Text(clue ?? 'The clue has not been added 🥴',
            style: const TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.center),
      ),
    );
  }
}

/*

 Widget build(BuildContext context) {
    return ExpansionTile(
      key: GlobalKey(),
          onExpansionChanged: (bool isExpending) => onChanged(isExpending),
          initiallyExpanded: false,
          leading: const Icon(Icons.info_outline, color: Colors.blue),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Clue',
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start),
              Text('takes 2 points',
                  style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start),
            ],
          ),
          children: [
            Text(clue ?? 'The clue has not been added 🥴',
                style: const TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.center)
          ],
        );
  }
 */