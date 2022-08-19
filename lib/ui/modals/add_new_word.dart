import 'package:auto_route/auto_route.dart';
import 'package:blaa/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/data/repositories/auth_repo.dart';
import 'package:blaa/ui/screens/demo_screen/bloc/demo_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewWord extends StatefulWidget {
  const AddNewWord({Key? key}) : super(key: key);

  @override
  _AddNewWordState createState() => _AddNewWordState();
}

class _AddNewWordState extends State<AddNewWord> {
  final TextEditingController _wordCtrl = TextEditingController();
  final TextEditingController _translationCtrl = TextEditingController();
  final TextEditingController _categoryCtrl = TextEditingController();
  final TextEditingController _clueCtrl = TextEditingController();
  final GlobalKey<FormState> _addNewWordModalFormKey = GlobalKey<FormState>();
  bool _isFavorite = false;
  String _native = 'English - demo';
  String _toLearn = 'Polish - demo';

  Word _handleSubmit() {
    Word item = Word(
      category: _categoryCtrl.value.text,
      clue: _clueCtrl.value.text,
      inNative: _wordCtrl.value.text,
      inTranslation: _translationCtrl.value.text,
      id: DateTime.now().millisecondsSinceEpoch,
      langToLearn: _toLearn,
      nativeLang: _native,
      isFavorite: _isFavorite == true ? 1 : 0,
    ); // temporary
    context.router.pop();
    return item;
  }

  @override
  void initState() {
    _isFavorite = false;
    String? _nativeFromState =
        context.read<AuthenticationBloc>().state.user?.nativeLang;
    String? _toLearnFromState =
        context.read<AuthenticationBloc>().state.user?.langToLearn;
    _native = _nativeFromState ?? _native;
    _toLearn = _toLearnFromState ?? _toLearn;
    super.initState();
  }

  @override
  void dispose() {
    _wordCtrl.clear();
    _translationCtrl.clear();
    _categoryCtrl.clear();
    _clueCtrl.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final AuthStatus _st = context.read<AuthenticationBloc>().state.status;
    final String _cat = AppLocalizations.of(context)?.category ?? 'Category';
    final String _clue = AppLocalizations.of(context)?.clue ?? 'Clue';
    final String _fav = AppLocalizations.of(context)?.favorite ?? 'Favorite';
    final String _cancel = AppLocalizations.of(context)?.cancel ?? 'Cancel';
    final String _submit = AppLocalizations.of(context)?.submit ?? 'Submit';
    final bool _isAuthenticated =
        context.read<AuthenticationBloc>().state.status ==
                AuthStatus.authenticated
            ? true
            : false;
    return Form(
      key: _addNewWordModalFormKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _buildFormField(_native, _wordCtrl),
        _buildFormField(_toLearn, _translationCtrl),
        _buildFormField(_cat, _categoryCtrl),
        _buildFormField(_clue, _clueCtrl),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(children: [
              Text(_fav),
              Checkbox(
                activeColor: Colors.green.shade400,
                value: _isFavorite,
                onChanged: (bool? value) {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
            ]),
            TextButton(
                onPressed: () => context.router.pop(), child: Text(_cancel)),
            TextButton(
                onPressed: () {
                  if (_isAuthenticated) {
                    context.read<WordsCubit>().addNewWord(_handleSubmit());
                  } else {
                    context.read<DemoCubit>().addNewWord(_handleSubmit());
                  }
                },
                child: Text(_submit)),
          ],
        ),
      ]),
    );
  }

  Padding _buildFormField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: TextFormField(
          controller: ctrl,
          maxLines:
              (label == 'clue' || label == AppLocalizations.of(context)?.clue)
                  ? 2
                  : 1,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(color: Color(0xff0E9447), width: 2.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(color: Color(0xff0E9447), width: 2.0),
            ),
            // isCollapsed: true,
            floatingLabelStyle: const TextStyle(
              color: Colors.green,
            ),
            labelText: label,
            labelStyle: const TextStyle(fontSize: 12),
          )),
    );
  }
}
