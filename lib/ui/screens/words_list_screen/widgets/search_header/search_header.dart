import 'package:blaa/ui/screens/words_list_screen/widgets/custom_search_delegate/custom_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _search =
        '${AppLocalizations.of(context)?.wordsListSearch}...';
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      snap: true,
      title: Text(_search),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            }),
      ],
    );
  }
}
