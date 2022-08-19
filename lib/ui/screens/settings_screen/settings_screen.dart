import 'package:auto_route/auto_route.dart';
import 'package:blaa/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/ui/router/blaa_router.gr.dart';
import 'package:blaa/ui/screens/settings_screen/language_picker/language_picker.dart';
import 'package:blaa/ui/widgets/banner/show_custom_banner.dart';
import 'package:blaa/ui/widgets/snack/show_custom_snack.dart';
import 'package:blaa/utils/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation orient = MediaQuery.of(context).orientation;
    Orientation port = Orientation.portrait;
    final bool isPortrait = orient == port;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: isPortrait ? 30 : 100),
            key: const Key('settings-screen'),
            shrinkWrap: true,
            children: [
              const Divider(thickness: 1.2),
              ListTile(
                title: TextButton(
                    onPressed: () => context.router.push(const LoginRoute()),
                    child: const Text('Sign in',
                        style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.start)),
                leading:
                    IconButton(icon: const Icon(Icons.login), onPressed: () => context.router.push(const LoginRoute())),
              ),
              const Divider(thickness: 1.2),
              ListTile(
                title: TextButton(
                    onPressed: () => context.router.push(const RegistrationRoute()),
                    child: const Text('Sign up',
                        style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.start)),
                leading: IconButton(
                    icon: const Icon(Icons.account_box_outlined),
                    onPressed: () => context.router.push(const RegistrationRoute())),
              ),
              const Divider(thickness: 1.2),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return ListTile(
                    title: TextButton(
                        onPressed: () => _handleLogoutRequest(context),
                        child: const Text('Sign out',
                            style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.start)),
                    leading: IconButton(icon: const Icon(Icons.logout), onPressed: () => _handleLogoutRequest(context)),
                  );
                },
              ),
              const Divider(thickness: 1.2),
              // App language picker - Locale
              ListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  leading: const Icon(Icons.translate),
                  title: LanguagePicker(
                      currentLocale: Localizations.localeOf(context).languageCode,
                      allL10nLanguages: L10n.allWithFullName)),
              const Divider(thickness: 1.2),
              _buildOtherSettingsTile(),
            ],
          ),
        ),
      ],
    );
  }

  void _handleLogoutRequest(BuildContext context) {
    context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
    showSnack(context, 'You have successfully Logged out');
  }

  BlocBuilder<WordsCubit, WordsState> _buildOtherSettingsTile() {
    return BlocBuilder<WordsCubit, WordsState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: const EdgeInsets.only(left: 30),
          leading: const Icon(Icons.more_horiz_rounded),
          title: ExpansionTile(
              title: const Text(
                'Others',
                style: TextStyle(fontSize: 19, color: Colors.black, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              children: [_buildDeleteAllWords(context)]),
        );
      },
    );
  }

  ListTile _buildDeleteAllWords(BuildContext context) {
    return ListTile(
        // contentPadding: const EdgeInsets.symmetric(horizontal: 3.0),
        leading: const Text('Delete all your words: ',
            style: TextStyle(fontSize: 15, color: Colors.black), textAlign: TextAlign.start),
        title: _buildDeleteBtn(context));
  }

  Padding _buildDeleteBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 5.0),
      child: TextButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(2.0),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
            shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
            // maximumSize: MaterialStateProperty.all<Size>(Size(15.0, 8.0)),
          ),
          onPressed: () => _showConfirmationBanner(context),
          child: const Icon(Icons.delete_forever_outlined, color: Colors.red)),
    );
  }

  void _showConfirmationBanner(BuildContext context) {
    return showBanner(context,
        'Delete all words permanently?',
      actionButtonText: 'Yes, delete',
        actionButtonHandle: () async {
          int number = await context.read<WordsCubit>().deleteAll();
          print('$number words was deleted from device memory');
          // showBanner(context, '$number words was deleted from device memory');
        },
      /*TextButton(
            onPressed: () => context.read<WordsCubit>().deleteAll(),
            child: const Text('Yes, delete', style: TextStyle(color: Colors.red)))*/);
  }
}
