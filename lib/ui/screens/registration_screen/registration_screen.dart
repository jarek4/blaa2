import 'package:blaa/data/repositories/auth_repo.dart';
import 'package:blaa/domain/repository/auth_repo_i.dart';
import 'package:blaa/ui/responsive_with_safe_area/responsive_with_safe_area.dart';
import 'package:blaa/ui/screens/registration_screen/layouts/registration_screen_layouts.dart';
import 'package:blaa/ui/widgets/snack/show_custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/registration_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _hello =
        AppLocalizations.of(context)?.welcome.toUpperCase() ?? 'WELCOME';
    return BlocProvider(
      create: (context) => RegistrationCubit(
          authenticationRepository: context.read<AuthRepoI<AuthStatus>>()),
      child: Center(
        child: BlocListener<RegistrationCubit, RegistrationState>(
            listener: (context, state) {
          if (state.formStatus == FormSubmissionStatus.failed) {
            showSnack(context, state.errorMessage);
          }
        }, child: BlocBuilder<RegistrationCubit, RegistrationState>(
          builder: (context, state) {
            if (state.formStatus == FormSubmissionStatus.success) {
              return Center(
                  child: Column(
                children: [
                  Text('$_hello ${state.username}'),
                  const Text('You are signed in. Let`s start...'),
                ],
              ));
            } else {
              return ResponsiveWithSafeArea(
                builder: (BuildContext context, BoxConstraints constraints,
                    Size size) {
                  if (constraints.maxWidth < 600) {
                    return const RegistrationNarrowed();
                  } else if (constraints.maxWidth > 600) {
                    return const RegistrationWidened();
                  } else {
                    return const RegistrationNarrowed();
                  }
                },
              );
            }
          },
        )),
      ),
    );
  }
}
