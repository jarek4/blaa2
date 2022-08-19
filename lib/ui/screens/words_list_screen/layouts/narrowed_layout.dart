import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/ui/screens/words_list_screen/widgets/search_header/search_header.dart';
import 'package:blaa/ui/screens/words_list_screen/widgets/words_list/words_list.dart';
import 'package:blaa/ui/widgets/order_bar/order_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NarrowedLayout extends StatelessWidget {
  const NarrowedLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const SearchHeader(),
      SliverList(
        delegate: SliverChildListDelegate([
          OrderBar(
              handleOnlyFavorite:
                  context.read<WordsCubit>().toggleShowOnlyFavored,
              handleOrder: context.read<WordsCubit>().orderItemsListByCreated),
        ]),
      ),
      BlocBuilder<WordsCubit, WordsState>(
        builder: (context, state) => _buildWordListWidget(context, state),
      )
    ]);
  }

  Widget _buildWordListWidget(context, state) {
    /// TODO: check for state.status - if failure show state.errorText
    /// if user has no permission show state.errorText
    List<Word> _itemsToDisplay = state.words;
    late List<Word> _filteredItems;
    final bool _onlyFav = state.isShowOnlyFavored;
    if (_onlyFav) {
      _filteredItems = List.of(_itemsToDisplay)
        ..removeWhere((e) => e.isFavorite == 0);
    } else {
      _filteredItems = _itemsToDisplay;
    }
    return WordsList(
      itemsToDisplay: _filteredItems,
      // cardOnTap: (BuildContext ctx, Word item) =>
      //     ctx.router.push(EditWordRoute(word: item, id: item.id)),
    );
  }
}
