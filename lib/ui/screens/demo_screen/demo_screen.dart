import 'package:auto_route/auto_route.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/ui/responsive_with_safe_area/responsive_with_safe_area.dart';
import 'package:blaa/ui/widgets/empty_words_list_info/empty_words_list_info.dart';
import 'package:blaa/ui/widgets/order_bar/order_bar.dart';
import 'package:blaa/ui/widgets/words_list_item/words_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../router/blaa_router.gr.dart';
import 'bloc/demo_cubit.dart';

/*
DemoScreen is shown only when user is not authenticated (no logged in user)
"+ new word" floating button adds new created word only to DemoCubit state
in this case created by user words are not saved into local database!
Words list items are supplied from DemoCubit state.words
To use the functionality of persist the words in the database, the user must log in!
 */
class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  late bool onlyFavoriteCheckboxValue;
  late bool _isOrderedFromOldest;

  @override
  void initState() {
    onlyFavoriteCheckboxValue = false;
    _isOrderedFromOldest = false;
    super.initState();
  }

  void _listOrdering(bool isOldestFirst) {
    setState(() {
      _isOrderedFromOldest = isOldestFirst;
    });
    context.read<DemoCubit>().orderFromOldest(_isOrderedFromOldest);
  }

  void _toggleShowOnlyFavorite(bool isOnly) {
    setState(() {
      onlyFavoriteCheckboxValue = !onlyFavoriteCheckboxValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWithSafeArea(
        builder: (BuildContext context, BoxConstraints constraints, Size size) {
      Orientation _orient = MediaQuery.of(context).orientation;
      Orientation _port = Orientation.portrait;
      return Container(
        padding:
            EdgeInsets.symmetric(horizontal: _orient == _port ? 5.0 : 60.0),
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
            flex: _orient == _port ? 1 : 2,
            child: ListView(
                key: const Key('DemoScreen-searching-control-topBar'),
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 8),
                      child: Column(children: [
                        OrderBar(
                            handleOnlyFavorite: _toggleShowOnlyFavorite,
                            handleOrder: _listOrdering),
                        Padding(
                            padding: EdgeInsets.only(
                                top: _orient == _port ? 15.0 : 3.0, bottom: 10),
                            child: const Text(
                              'DEMO MODE',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.deepPurple),
                            )),
                      ]))
                ]),
          ),
          Flexible(
            flex: _orient == _port ? 3 : 5,
            child: BlocBuilder<DemoCubit, DemoState>(
                builder: (BuildContext context, DemoState state) {
              switch (state.status) {
                case DemoStateStatus.loading:
                  return Center(
                    child: Column(children: const <Widget>[
                      CircularProgressIndicator(color: Colors.green)
                    ]),
                  );
                case DemoStateStatus.success:
                  final List<Word> _list = state.words;
                  late List<Word> _filteredList;
                  if (onlyFavoriteCheckboxValue) {
                    _filteredList = List.of(_list)
                      ..removeWhere((e) => e.isFavorite == 0);
                  } else {
                    _filteredList = state.words;
                  }
                  final int _c = _filteredList.length;
                  return ListView.builder(
                      key: const Key('DemoScreen-wordsList_builder'),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      // if list is empty, want to show EmptyWordsListInfo - one item
                      itemCount: _c < 1 ? 1 : _c,
                      itemBuilder: (BuildContext context, int index) {
                        if (_filteredList.isEmpty) {
                          return const EmptyWordsListInfo();
                        } else {
                          final Word _word = _filteredList[index];
                          return WordsListItem(
                              key: Key('DemoScreen-wordsListItem-${_word.id}'),
                              item: _word,
                              favHandle: () => context
                                  .read<DemoCubit>()
                                  .triggerFavorite(_word.id),
                              deleteHandle: () =>
                                  context.read<DemoCubit>().delete(_word.id),
                              onTapHandle: () => context.router
                                  .push(SingleRoute(itemId: _word.id)));
                        }
                      });
                case DemoStateStatus.failure:
                  return Center(
                    child: Column(
                      children: const <Widget>[
                        CircularProgressIndicator(
                          color: Colors.green,
                        ),
                        Text('Please, try again. 🙄 😮'),
                        Text('Error: ___'),
                      ],
                    ),
                  );
                default:
                  return Center(
                    child: Column(children: const <Widget>[
                      CircularProgressIndicator(color: Colors.red),
                      Text('Please, try again. Something go wrong 🙄 😮'),
                    ]),
                  );
              }
            }),
          ),
        ]),
      );
    });
  }
}
