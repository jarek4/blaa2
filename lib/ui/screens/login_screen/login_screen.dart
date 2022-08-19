import 'package:blaa/data/repositories/auth_repo.dart';
import 'package:blaa/domain/repository/auth_repo_i.dart';
import 'package:blaa/ui/responsive_with_safe_area/responsive_with_safe_area.dart';
import 'package:blaa/ui/screens/login_screen/layouts/login_screen_layouts.dart';
import 'package:blaa/ui/widgets/banner/show_custom_banner.dart';
import 'package:blaa/ui/widgets/snack/show_custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/login_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String underDev = AppLocalizations.of(context)?.msgUnderDev ??
        'Feature under preparation';
    final String hello =
        AppLocalizations.of(context)?.welcome.toUpperCase() ?? 'WELCOME';
    final String signedAs =
        AppLocalizations.of(context)?.msgSignedInAs ?? 'You are signed in as';
    final String invalid =
        AppLocalizations.of(context)?.msgInvalid ?? 'is not valid';
    return BlocProvider<LoginBloc>(
      create: (_) => LoginBloc(
          authenticationRepository: context.read<AuthRepoI<AuthStatus>>()),
      child: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) {
          return previous.errorMsg != current.errorMsg ||
              previous.status != current.status;
        },
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            showSnack(context, state.errorMsg);
          }
          if (state.status == LoginStatus.forgotPass) {
            final String? errorMsg = state.errorMsg;
            String? email = state.email;
            String msg =
                errorMsg == 'notReady' ? underDev : 'Email: $email $invalid.';
            showBanner(context, msg);
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state.status == LoginStatus.success) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(hello),
                      const SizedBox(height: 5.0),
                      Text('$signedAs: ${state.email}'),
                      const SizedBox(height: 5.0),
                      const Text('Let`s go...'),
                    ],
                  ),
                ),
              );
            } else {
              return ResponsiveWithSafeArea(
                builder: (BuildContext context, BoxConstraints constraints,
                    Size size) {
                  if (constraints.maxWidth < 600) {
                    return const NarrowedLayout();
                  } else {
                    return const WidenedLayout();
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
