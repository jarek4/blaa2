import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/ui/screens/edit_word_screen/edit_word_screen.dart';
import 'package:blaa/ui/screens/words_list_screen/widgets/search_header/search_header.dart';
import 'package:blaa/ui/screens/words_list_screen/widgets/words_list/words_list.dart';
import 'package:blaa/ui/widgets/order_bar/order_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidenedLayout extends StatefulWidget {
  const WidenedLayout({Key? key}) : super(key: key);

  @override
  State<WidenedLayout> createState() => WidenedLayoutState();
}

class WidenedLayoutState extends State<WidenedLayout> {
  Word? _sel;

  @override
  void initState() {
    _sel = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: CustomScrollView(slivers: [
            // Custom Search delegate
            const SearchHeader(),
            SliverList(
              delegate: SliverChildListDelegate([
                // Show only favorite, Ordering from new/ old
                OrderBar(
                    handleOnlyFavorite:
                        context.read<WordsCubit>().toggleShowOnlyFavored,
                    handleOrder:
                        context.read<WordsCubit>().orderItemsListByCreated),
              ]),
            ),
            BlocBuilder<WordsCubit, WordsState>(
              builder: (context, state) => _buildWordListWidget(context, state),
            )
          ]),
        ),
        Expanded(
          flex: 3,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey, width: 2.0)),
            ),
            child: _sel == null
                ? const Center(
                    child: Text('🦒', style: TextStyle(fontSize: 40)))
                : EditWordScreen(word: _sel!, id: _sel!.id),
          ),
        )
      ],
    );
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
        cardOnTap: (BuildContext ctx, Word item) {
          setState(() {
            _sel = item;
          });
        });
  }
}
