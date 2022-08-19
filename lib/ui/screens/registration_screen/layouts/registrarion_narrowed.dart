import 'package:auto_route/auto_route.dart';
import 'package:blaa/ui/router/blaa_router.gr.dart';
import 'package:blaa/ui/screens/registration_screen/bloc/registration_cubit.dart';
import 'package:blaa/ui/widgets/form_submit_btn/form_submit_btn.dart';
import 'package:blaa/ui/widgets/language_select/language_dropdown/language_dropdown.dart';
import 'package:blaa/utils/authentication/build_input_decoration.dart';
import 'package:blaa/utils/constants/assets_const.dart';
import 'package:blaa/utils/constants/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationNarrowed extends StatefulWidget {
  const RegistrationNarrowed({Key? key}) : super(key: key);

  @override
  State<RegistrationNarrowed> createState() => _RegistrationNarrowedState();
}

class _RegistrationNarrowedState extends State<RegistrationNarrowed> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _registerFormKye =
      GlobalKey<FormState>(debugLabel: 'Register form narrow');
  bool _isHidden = true;
  static const _passPattern2 = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$';
  static const _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  @override
  void dispose() {
    _passwordCtrl.clear();
    _emailCtrl.clear();
    _nameCtrl.clear();
    super.dispose();
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String _toLearn = AppLocalizations.of(context)?.registerLanguage ??
        'Language You want to learn';
    final String _native =
        AppLocalizations.of(context)?.registerNative ?? 'Your native language';
    return CustomScrollView(slivers: [
      SliverList(
        delegate: SliverChildListDelegate([
          Form(
            key: _registerFormKye,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: 'hero',
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 48.0,
                      child: Image.asset(AssetsConst.bulbTr['path']!),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _nameField('Name', _nameCtrl),
                  const SizedBox(height: 8.0),
                  _emailField('Email', _emailCtrl),
                  const SizedBox(height: 8.0),
                  _passwordField('Password', _passwordCtrl),
                  const SizedBox(height: 15.0),
                  Text(_native,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center),
                  _buildMyLanguageDropdown(context),
                  const SizedBox(height: 8.0),
                  Text(_toLearn,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center),
                  _buildWantLearnDropdown(context),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 35),
                      child: BlocBuilder<RegistrationCubit, RegistrationState>(
                        builder: (context, state) {
                          if (state.formStatus ==
                              FormSubmissionStatus.submitting) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Colors.grey,
                            ));
                          } else {
                            return FormSubmitBtn(
                              key: const Key('register-wind'),
                              formState: _registerFormKye.currentState,
                              txt: 'Sign Up',
                              onSubmit: () => context
                                  .read<RegistrationCubit>()
                                  .onFormSubmit(),
                            );
                          }
                        },
                      )),
                  _buildSignInOption(context)
                ],
              ),
            ),
          )
        ]),
      ),
    ]);
  }

  // --------------- ----------------
  Padding _buildSignInOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: TextButton(
        child: const Text(
          'Sign In',
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        onPressed: () => context.router.replace(const LoginRoute()),
      ),
    );
  }

  Widget _nameField(String label, TextEditingController ctrl) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
          child: TextFormField(
              cursorColor: Colors.black,
              maxLength: 30,
              // the item is responsible for validation!
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[ a-zA-Z0-9 -]'),
                    replacementString: ' a-z 0-9 allowed ')
              ],
              onChanged: (val) =>
                  context.read<RegistrationCubit>().onUsernameChanged(val),
              validator: (v) => state.isUsernameValid ? null : 'Enter name',
              keyboardType: TextInputType.text,
              obscureText: false,
              controller: ctrl,
              decoration: inputDecoration(label: label)),
        );
      },
    );
  }

  Widget _emailField(String label, TextEditingController ctrl) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
        builder: (context, state) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
        child: TextFormField(
            cursorColor: Colors.black,
            maxLength: 40,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.deny(
                  RegExp("['+;=?!*^%#([\\)<>/&/,\":]"),
                  replacementString: '-not allowed')
            ],
            onChanged: (val) =>
                context.read<RegistrationCubit>().onEmailChanged(val),
            validator: (v) {
              if (v != null) {
                // the item is responsible for validation!
                bool _emailValid = RegExp(_emailPattern).hasMatch(v);
                if (!_emailValid || v.isEmpty) {
                  return 'Email ${AppLocalizations.of(context)?.msgInvalid ?? 'is not valid'}!';
                } else {
                  return null;
                }
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            controller: ctrl,
            decoration: inputDecoration(label: label)),
      );
    });
  }

  Widget _passwordField(String label, TextEditingController ctrl) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
        builder: (context, state) {
      return BlocListener<RegistrationCubit, RegistrationState>(
        listenWhen: (previous, current) {
          return previous.errorMessage != current.errorMessage ||
              previous.formStatus != current.formStatus;
        },
        listener: (context, state) {
          if (state.formStatus == FormSubmissionStatus.failed) {
            setState(() {
              _passwordCtrl.text = '';
              _emailCtrl.text = '';
              _nameCtrl.text = '';
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
          child: TextFormField(
            cursorColor: Colors.black,
            onChanged: (val) =>
                context.read<RegistrationCubit>().onPasswordChanged(val),
            // the item is responsible for validation!
            validator: (v) {
              if (v != null) {
                bool _passValid = RegExp(_passPattern2).hasMatch(v);
                if (v.isEmpty) {
                  return 'Password cannot be empty!';
                } else if (!_passValid) {
                  return 'Invalid password - e.g. Aa!123';
                } else {
                  return null;
                }
              }
              return null;
            },
            keyboardType: TextInputType.visiblePassword,
            obscureText: _isHidden,
            controller: ctrl,
            decoration: inputDecoration(
                label: label,
                togglePassVisibility: _togglePasswordView,
                isPassHidden: _isHidden),
          ),
        ),
      );
    });
  }

  Widget _buildMyLanguageDropdown(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 35),
        child: LanguageDropdown<String>(
            hintText:
                AppLocalizations.of(context)?.registerMyLang ?? 'My language',
            options: [...SupportedLanguages.names],
            value: state.nativeLang,
            onChanged: (String? newValue) {
              context.read<RegistrationCubit>().onNativeLangChanged(newValue!);
            },
            getLabel: (String value) => value,
            key: const Key('LanguageDropdown-My language')),
      );
    });
  }

  Widget _buildWantLearnDropdown(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 35),
        child: LanguageDropdown<String>(
            hintText: AppLocalizations.of(context)?.registerWantToLearn ??
                'I want to learn',
            options: [...SupportedLanguages.names],
            value: state.langToLearn,
            onChanged: (String? newValue) {
              context.read<RegistrationCubit>().onLangToLearnChanged(newValue!);
            },
            getLabel: (String value) => value,
            key: const Key('LanguageDropdown-I want to learn')),
      );
    });
  }
}
