import 'package:blaa/ui/widgets/quiz/clue/expandable_section.dart';
import 'package:blaa/ui/widgets/quiz/clue/rotatable_section.dart';
import 'package:flutter/material.dart';

class ExpandableListTile extends StatelessWidget {
  const ExpandableListTile(
      {Key? key, required this.title, required this.expanded, required this.onExpandPressed, required this.child})
      : super(key: key);
  final Widget title;
  final bool expanded;
  final Widget child;
  final VoidCallback onExpandPressed;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
        leading: Icon(Icons.info_outline_rounded, color: Colors.blue,),
        title: title,
        onTap: onExpandPressed,
        trailing: IconButton(
          onPressed: onExpandPressed,
          // icon: Icon(Icons.expand_more),
          icon: RotatableSection(
              rotated: expanded,
              child: const SizedBox(
                height: 30,
                width: 30,
                child: Icon(Icons.expand_more),
              )),
        ),
      ),
      ExpandableSection(
        expand: expanded,
        child: child,
      )
    ]);
  }
}
