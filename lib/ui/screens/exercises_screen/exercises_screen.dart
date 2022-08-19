import 'package:auto_route/auto_route.dart';
import 'package:blaa/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/domain/repository/words_repo_i.dart';
import 'package:blaa/ui/router/blaa_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  double tileHeight = 20.5;

  static const Orientation landscape = Orientation.landscape;

  static final exercises = <Map<String, dynamic>>[
    {
      'title': 'Quiz',
      'description': '''Select the correct translation of the given word. 
      You gain 5 points if the first answer is correct, 3 - if second.
      Opening the clue takes you 2 points''',
      'link': const ExerciseCorrectAnswer()
    },
    {
      'title': 'Exercise is not ready',
      'description': 'This section is under development.\nIt does not work now',
      'link': null
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return BlocProvider(
      create: (context) => WordsCubit(
        context.read<WordsRepoI<Word>>(),
        context.read<AuthenticationBloc>(),
      ),
      child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: 2.2,
          crossAxisCount: orientation == landscape ? 2 : 1,
          mainAxisSpacing: 10.0,
          children: exercises
              .map((e) => _exerciseCard(
                  title: e['title']?.toUpperCase() ?? 'Title',
                  description: e['description'] ?? 'Description',
                  route: e['link']))
              .toList()),
    );
  }

  Widget _exerciseCard({String title = 'Exercise', String description = 'no description', PageRouteInfo? route}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Card(
        color: Colors.grey.shade300,
        child: BlocSelector<WordsCubit, WordsState, int>(
          selector: (state) {
            return state.words.length;
            // return selected state
          },
          builder: (context, state) {
            final bool isMoreThen3 = state >= 3;
            final bool isQuizBtnDisabled = !isMoreThen3 && route == const ExerciseCorrectAnswer();
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: ElevatedButton(
                    key: Key(title.substring(0, 4)),
                    onPressed:
                        (route != null && isMoreThen3) ? () => context.router.push(Exercise(children: [route])) : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          (route != null && isMoreThen3) ? Colors.grey : Colors.grey.shade400),
                      // textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontStyle: FontStyle.italic)),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(10.0)),
                    ),
                    child: Text(
                      'Start',
                      style: TextStyle(
                        color: route != null ? Colors.black : Colors.grey.shade600,
                        decoration: isQuizBtnDisabled ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationColor: Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
                if (isQuizBtnDisabled)
                  const Text(
                    'You need at least 3 words to play!',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
