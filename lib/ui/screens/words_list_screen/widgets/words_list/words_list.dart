import 'package:auto_route/auto_route.dart';
import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/ui/router/blaa_router.gr.dart';
import 'package:blaa/ui/widgets/words_list_item/words_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WordsList extends StatelessWidget {
  const WordsList({Key? key, required itemsToDisplay, cardOnTap})
      : _itemsToDisplay = itemsToDisplay,
        _cardOnTap = cardOnTap,
        super(key: key);

  final List<Word> _itemsToDisplay;
  final Function(BuildContext context, Word item)? _cardOnTap;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int i) {
          Word _item = _itemsToDisplay[i];
          return WordsListItem(
              key: Key('WordsListScreen-wordsListItem-${_item.id}'),
              item: _item,
              favHandle: () =>
                  context.read<WordsCubit>().triggerFavorite(_item.id),
              deleteHandle: () => context.read<WordsCubit>().delete(_item.id),
              onTapHandle: () {
                if (_cardOnTap == null) {
                  context.router.push(EditWordRoute(word: _item, id: _item.id));
                } else {
                  _cardOnTap!(context, _item);
                }
              });
        },
        childCount: _itemsToDisplay.length,
      ),
    );
  }
}