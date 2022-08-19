import 'package:auto_route/auto_route.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/ui/modals/bottom_modals/edition_bottom_modal.dart';
import 'package:blaa/ui/screens/demo_screen/bloc/demo_cubit.dart';
import 'package:blaa/utils/constants/assets_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SingleScreen extends StatelessWidget {
  const SingleScreen({Key? key, @PathParam() required this.itemId})
      : super(key: key);

  final int itemId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5.0),
      child: Hero(
        transitionOnUserGestures: true,
        tag: itemId,
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
                _buildId(itemId.toString()),
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
        child: BlocBuilder<DemoCubit, DemoState>(builder: (context, state) {
          Word _item = _findSingleWordInStateById(itemId, state.words);
          if (_item.imageAsString != '' && _item.imageAsString != null) {
            return Image(
              fit: BoxFit.cover,
              image: AssetImage(AssetsConst.bag['path']!),
            );
          } else {
            return _buildWordImageReplacement(_item.inTranslation);
          }
        }),
      ),
      Positioned(
          right: 3,
          bottom: -12,
          child: BlocBuilder<DemoCubit, DemoState>(
            builder: (context, state) {
              Word _item = _findSingleWordInStateById(itemId, state.words);
              return IconButton(
                  // onPressed: () {},
                  onPressed: () =>
                      context.read<DemoCubit>().triggerFavorite(_item.id),
                  icon: _item.isFavorite == 1
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
        child: BlocBuilder<DemoCubit, DemoState>(
          builder: (context, state) {
            Word _item = _findSingleWordInStateById(itemId, state.words);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_item.langToLearn}: ',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal)),
                Text(_item.inTranslation,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () => editField(
                        context: context,
                        description: _item.langToLearn,
                        value: _item.inTranslation,
                        handle: context.read<DemoCubit>().editInTranslation),
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
        child: BlocBuilder<DemoCubit, DemoState>(
          builder: (context, state) {
            Word _item = _findSingleWordInStateById(itemId, state.words);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_item.nativeLang}: ',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal)),
                Text(_item.inNative,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () => editField(
                        context: context,
                        description: _item.nativeLang,
                        value: _item.inNative,
                        handle: context.read<DemoCubit>().editInNative),
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
            final String? _created = context
                .watch<DemoCubit>()
                .state
                .words
                .firstWhere((e) => e.id == itemId)
                .created;
            return Text(
              'Created at:  ${_created ?? '00-00-00'}',
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
        child: BlocBuilder<DemoCubit, DemoState>(
          builder: (context, state) {
            Word _item = _findSingleWordInStateById(itemId, state.words);
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${AppLocalizations.of(context)?.category ?? 'Category'}: ',
                      style:
                          const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(_item.category ?? 'no category added',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal)),
                  TextButton(
                      onPressed: () => editField(
                          context: context,
                          description: AppLocalizations.of(context)?.category ?? 'Category',
                          value: '${_item.category}',
                          handle: context.read<DemoCubit>().editCategory),
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Color(0xff0E9447)),
                      ))
                ]);
          },
        ));
  }

  Container _moreSectionClue() {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
        alignment: Alignment.topLeft,
        child: BlocBuilder<DemoCubit, DemoState>(
          builder: (context, state) {
            Word _item = _findSingleWordInStateById(itemId, state.words);
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
                              description: AppLocalizations.of(context)?.clue ?? 'Clue',
                              value: _item.clue,
                              handle: context.read<DemoCubit>().editClue),
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: Color(0xff0E9447)),
                          ))
                    ]),
                Text(
                  _item.clue ?? 'no clue was added',
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
        child: BlocBuilder<DemoCubit, DemoState>(builder: (context, state) {
          return BlocBuilder<DemoCubit, DemoState>(
            builder: (context, state) {
              Word _item = _findSingleWordInStateById(itemId, state.words);
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Points: ',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(_item.points.toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal)),
                    TextButton(
                        onPressed: () =>
                            context.read<DemoCubit>().resetPoints(itemId),
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Color(0xff0E9447)),
                        ))
                  ]);
            },
          );
        }));
  }

  Container _buildId(String id) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      alignment: Alignment.topLeft,
      child: Text('ID: $id',
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.normal)),
    );
  }

  Word _findSingleWordInStateById(int id, List<Word> state) {
    Word _single = state.firstWhere((element) => element.id == id,
        orElse: () =>
            const Word(inNative: 'Error', inTranslation: 'occurred', id: -100));
    return _single;
  }

  void editField(
      {required BuildContext context,
      String? description,
      String? value,
      Function? handle}) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return EditionBottomModal(
            itemId: itemId,
            description: description,
            value: value,
            handle: handle ?? () {},
          );
        });
  }
}
