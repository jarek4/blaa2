import 'package:auto_route/auto_route.dart';
import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/ui/router/blaa_router.gr.dart';
import 'package:blaa/ui/widgets/empty_words_list_info/empty_words_list_info.dart';
import 'package:blaa/ui/widgets/words_list_item/words_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    // assert(context != null);
    final ThemeData theme = Theme.of(context);
    // theme.copyWith(backgroundColor: Colors.amber);
    // assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // to clear the query - input (right end of the search bar)
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              // close and leave search bar
              close(context, null);
            } else {
              // clear the query
              query = '';
            }
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // to leave and close search bar, back to prev screen (left end of the search bar)
    return Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using

    return BlocBuilder<WordsCubit, WordsState>(
        builder: (BuildContext context, WordsState state) {
      switch (state.status) {
        case WordsStateStatus.loading:
          return Center(
            child: Column(children: const <Widget>[
              CircularProgressIndicator(color: Colors.green)
            ]),
          );
        case WordsStateStatus.success:
          final List<Word> _list = state.words;
          final _results = _list
              .where(
                  (w) => w.inNative.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              key: const Key('WordsListScreen-wordsList_builder'),
              itemCount: _results.length,
              itemBuilder: (BuildContext context, int index) {
                if (_results.isEmpty) {
                  return const EmptyWordsListInfo();
                } else {
                  final Word _word = _results[index];
                  return WordsListItem(
                      key: Key('WordsListScreen-wordsListItem-${_word.id}'),
                      favHandle: () =>
                          context.read<WordsCubit>().triggerFavorite(_word.id),
                      deleteHandle: () =>
                          context.read<WordsCubit>().delete(_word.id),
                      item: _word);
                }
              });
        case WordsStateStatus.failure:
          return Center(
            child: Column(children: const <Widget>[
              CircularProgressIndicator(
                color: Colors.green,
              ),
              Text('Please, try again. 🙄 😮'),
              Text('Error: ___'),
            ]),
          );
        default:
          return Center(
            child: Column(children: const <Widget>[
              CircularProgressIndicator(color: Colors.red),
              Text('Please, try again. Something go wrong 🙄 😮'),
            ]),
          );
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //called everytime the search term (query) changes.
    return CustomScrollView(slivers: [
      SliverList(
        delegate: SliverChildListDelegate([
          Column(children: [
            BlocBuilder<WordsCubit, WordsState>(
                builder: (BuildContext context, WordsState state) {
              if (state.words.isEmpty) {
                return const Center(child: Text('No words, add some'));
              }
              final _suggestions = state.words
                  .where((w) =>
                      w.inNative.toLowerCase().contains(query.toLowerCase()))
                  .toList();
              return ListView(
                  shrinkWrap: true,
                  children: _suggestions
                      .map<Widget>((e) => WordsListItem(
                          key: Key('WordsListScreen-wordsListItem-${e.id}'),
                          onTapHandle: () => context.router
                              .push(EditWordRoute(word: e, id: e.id)),
                          // onTapHandle: () {
                          //   // when click one suggestion it will put it into the input
                          //   query = e.inNative;
                          //   showResults(context);
                          //   context.router
                          //       .push(EditWordRoute(word: e, id: e.id));
                          // },
                          favHandle: () =>
                              context.read<WordsCubit>().triggerFavorite(e.id),
                          deleteHandle: () =>
                              context.read<WordsCubit>().delete(e.id),
                          item: e))
                      .toList());
            }),
          ])
        ]),
      ),
    ]);
  }
}
