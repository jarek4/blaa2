import 'package:auto_route/auto_route.dart';
import 'package:blaa/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/domain/repository/words_repo_i.dart';
import 'package:blaa/ui/router/blaa_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildBtn(() => context.router.push(const WordsListRouter(children: [WordsListRoute()])), 'All Your words',
            Icons.assignment_outlined),
        // _buildBtn(() => _noPageDialog(context), 'Let\'s do exercises',
        //     Icons.accessibility_new),
        BlocProvider(
          create: (context) => WordsCubit(
            context.read<WordsRepoI<Word>>(),
            context.read<AuthenticationBloc>(),
          ),
          child: BlocBuilder<WordsCubit, WordsState>(
            builder: (context, state) {
              return _buildBtn(() => context.router.push(const ExercisesRouter(children: [Exercises()])),
                  'Let\'s do exercises', Icons.accessibility_new);
            },
          ),
        ),
        _buildBtn(
            // () => context.navigateTo(const HomeRouter(children: [DemoRoute()])),
            //   () => context.navigateTo(const DemoRoute()),
            () => context.navigateTo(const DemoRouter(children: [DemoRoute()])),
            'Demo',
            Icons.device_unknown),
      ],
    );
  }

  Card _buildBtn(VoidCallback handleOnPressed, String txt, IconData icon) {
    return Card(
      color: Colors.grey.shade300,
      child: MaterialButton(
        onPressed: handleOnPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [Icon(icon, size: 27), Text(txt, style: const TextStyle(fontSize: 18))],
          ),
        ),
      ),
    );
  }

  _noPageDialog(BuildContext ctx) => showDialog(
      barrierDismissible: true,
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('It will be ready soon'),
          actions: [
            TextButton(
              onPressed: () => context.router.pop(),
              child: const Text('Close'),
            )
          ],
        );
      });
}
