import 'package:auto_route/auto_route.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/domain/repository/words_repo_i.dart';
import 'package:blaa/ui/modals/bottom_modals/edition_bottom_modal.dart';
import 'package:blaa/ui/screens/edit_word_screen/cubit/edit_word_cubit.dart';
import 'package:blaa/utils/constants/assets_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditWordScreen extends StatelessWidget {
  const EditWordScreen(
      {Key? key, required this.word, @PathParam() required this.id})
      : super(key: key);

  // id is only for auto_route @PathParam()
  final int id;
  final Word word;
  // offset is needed to place the widget in the middle when horizontal layout (two rows)
  static final ScrollController ctr = ScrollController(initialScrollOffset: 100.0);

  @override
  Widget build(BuildContext context) {
    // final WordsRepoI<Word> _repository = context.read<WordsRepoI<Word>>();
    context.read<EditWordCubit>().setItem(word);
    return SingleChildScrollView(
      controller: ctr,
      padding: const EdgeInsets.all(5.0),
      child: Hero(
        transitionOnUserGestures: true,
        tag: word,
        child: Container(
          // height: 400,
          padding: const EdgeInsets.all(10.0),
          child: Card(
            color: Colors.grey[300],
            elevation: 40,
            shadowColor: Colors.grey[700],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            margin: const EdgeInsets.fromLTRB(30, 90, 30, 10),
            child: Column(
              children: [
                buildHead(),
                const SizedBox(height: 10),
                _buildInLanguageToLearnField(),
                _buildInNativeLanguageField(),
                const SizedBox(height: 10),
                _buildMoreSection(),
                const SizedBox(height: 4),
                _buildId(word.id.toString()),
                const SizedBox(height: 6)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack buildHead() {
    return Stack(children: [
      // ClipRRect image rounded corners
      ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BlocBuilder<EditWordCubit, EditWordState>(
              builder: (context, state) {
            String? _img = state.item.imageAsString;
            String _txt = state.item.inTranslation;
            if (_img != '' && _img != null) {
              return Image(
                fit: BoxFit.cover,
                image: AssetImage(AssetsConst.bag['path']!),
              );
            } else {
              return _buildWordImageReplacement(_txt);
            }
          })),
      Positioned(
          right: 3,
          bottom: -12,
          child: BlocBuilder<EditWordCubit, EditWordState>(
            builder: (context, state) {
              return IconButton(
                  // onPressed: () {},
                  onPressed: () => context
                      .read<EditWordCubit>()
                      .triggerFavorite(state.item.id),
                  icon: state.item.isFavorite == 1
                      ? Image.asset(
                          AssetsConst.iconHeartRed['path']!,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          AssetsConst.iconHeart['path']!,
                          height: 20.0,
                          fit: BoxFit.scaleDown,
                        ));
            },
          )),
      Positioned(right: 3, top: 3, child: _buildMenuBtn()),
    ]);
  }

  Container _buildWordImageReplacement(String translation) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 80.0,
      child: Align(
        alignment: Alignment.center,
        child: Text(translation[0].toUpperCase(),
            style: const TextStyle(
                color: Color(0xff0E9447),
                fontWeight: FontWeight.w800,
                fontSize: 32,
                decoration: TextDecoration.underline)),
      ),
    );
  }

  Widget _buildMenuBtn() {
    return PopupMenuButton(
      icon: const Icon(Icons.menu_outlined),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(
              children: const [Icon(Icons.cancel_outlined), Text("  Close")]),
        ),
        PopupMenuItem(
          child: Row(children: const [
            Icon(Icons.star_border_outlined),
            Text("  Add to Favorite")
          ]),
        ),
        PopupMenuItem(
          child: Row(children: const [Icon(Icons.delete), Text("  Remove")]),
        )
      ],
    );
  }

  Container _buildInLanguageToLearnField() {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
        alignment: Alignment.topLeft,
        child: BlocBuilder<EditWordCubit, EditWordState>(
          builder: (context, state) {
            String _toLearn = state.item.langToLearn;
            String _inTranslation = state.item.inTranslation;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$_toLearn: ',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal)),
                Text(_inTranslation,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () => editField(
                        context: context,
                        description: _toLearn,
                        value: _inTranslation,
                        handle:
                            context.read<EditWordCubit>().editInTranslation),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Color(0xff0E9447)),
                    ))
              ],
            );
          },
        ));
  }

  Container _buildInNativeLanguageField() {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
        alignment: Alignment.topLeft,
        child: BlocBuilder<EditWordCubit, EditWordState>(
          builder: (context, state) {
            String _native = state.item.nativeLang;
            String _inNative = state.item.inNative;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$_native: ',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal)),
                Text(_inNative,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () => editField(
                        context: context,
                        description: _native,
                        value: _inNative,
                        handle: context.read<EditWordCubit>().editInNative),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Color(0xff0E9447)),
                    ))
              ],
            );
          },
        ));
  }

  ExpansionTile _buildMoreSection() {
    return ExpansionTile(
      title: const Text('See more',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
      // subtitle: Text('Trailing expansion arrow icon'),
      children: <Widget>[
        _moreSectionCategory(),
        _moreSectionClue(),
        _moreSectionPoints(),
        Builder(
          builder: (context) {
            final String? _created =
                context.watch<EditWordCubit>().state.item.created;
            return Text(
              'Created at:  ${_created?.substring(0, 10) ?? '00-00-00'}',
              textAlign: TextAlign.left,
            );
          },
        ),
      ],
    );
  }

  Container _moreSectionCategory() {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
        alignment: Alignment.topLeft,
        child: Builder(
          builder: (context) {
            final String? _category =
                context.watch<EditWordCubit>().state.item.category;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${AppLocalizations.of(context)?.category ?? 'Category'}: ',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
                Text(_category ?? 'no category added',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal)),
                TextButton(
                    onPressed: () => editField(
                        context: context,
                        description: AppLocalizations.of(context)?.category ??
                            'Category',
                        value: _category ?? '',
                        handle: context.read<EditWordCubit>().editCategory),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Color(0xff0E9447)),
                    ))
              ],
            );
          },
        ));
  }

  Container _moreSectionClue() {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
        alignment: Alignment.topLeft,
        child: Builder(
          builder: (context) {
            final String? _clue =
                context.watch<EditWordCubit>().state.item.clue;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${AppLocalizations.of(context)?.clue ?? 'Clue'}: ',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () => editField(
                            context: context,
                            description:
                                AppLocalizations.of(context)?.clue ?? 'Clue',
                            value: _clue ?? '',
                            handle: context.read<EditWordCubit>().editClue),
                        child: const Text(
                          'Edit',
                          style: TextStyle(color: Color(0xff0E9447)),
                        ))
                  ],
                ),
                Text(
                  _clue ?? 'no clue was added',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            );
          },
        ));
  }

  Container _moreSectionPoints() {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
        alignment: Alignment.topLeft,
        child: Builder(
          builder: (context) {
            final int _points =
                context.watch<EditWordCubit>().state.item.points;
            final int _id = context.watch<EditWordCubit>().state.item.id;
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Points: ',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(_points.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal)),
                  TextButton(
                      onPressed: () =>
                          context.read<EditWordCubit>().resetPoints(_id),
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Color(0xff0E9447)),
                      ))
                ]);
          },
        ));
  }

  Container _buildId(String id) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      alignment: Alignment.topLeft,
      child: Text('ID: $id',
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.normal)),
    );
  }

  // EditionBottomModal onPressed: () { widget.handle(itemId, _ctr.value.text);}
  void editField(
      {required BuildContext context,
      String? description,
      String? value,
      Function? handle}) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return EditionBottomModal(
            itemId: word.id,
            description: description,
            value: value,
            handle: handle ?? () {},
          );
        });
  }
}
