import 'package:blaa/utils/constants/assets_const.dart';
import 'package:flutter/material.dart';

class EmptyWordsListInfo extends StatelessWidget {
  const EmptyWordsListInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(20)),
      child: ListTile(
          key: const Key('noItemsInListInfoListTile'),
          minVerticalPadding: 5,
          horizontalTitleGap: 15,
          isThreeLine: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          leading: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              color: Colors.grey,
              height: 50,
              width: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[
                      Text('new', style: TextStyle(fontSize: 10)),
                      Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.black,
                      ),
                      Text('word', style: TextStyle(fontSize: 10))
                    ]),
              ),
            ),
          ),
          title: const Text(
            'You have no words yet',
            textAlign: TextAlign.center,
          ),
          subtitle: Column(children: const [
            Text(' ⟪ use "+ new word" to add new one'),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Add to favorite or delete ⟫'),
            ),
          ]),
          trailing: _buildTrailingIcons()),
    );
  }

  Padding _buildTrailingIcons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
            child: Image.asset(AssetsConst.iconHeartRed['path']!)),
        const SizedBox(
          height: 8,
        ),
        const Expanded(
          child: Icon(Icons.delete_forever),
        )
      ]),
    );
  }
}
