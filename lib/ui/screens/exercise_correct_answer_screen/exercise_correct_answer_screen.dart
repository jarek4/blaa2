import 'package:auto_route/auto_route.dart';
import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/ui/screens/exercise_correct_answer_screen/cubit/quiz_cubit.dart';
import 'package:blaa/ui/widgets/quiz/option_widget.dart';
import 'package:blaa/ui/widgets/quiz/question_clue_widget.dart';
import 'package:blaa/ui/widgets/quiz/question_widget.dart';
import 'package:blaa/ui/widgets/quiz/quiz_header.dart';
import 'package:blaa/ui/widgets/snack/show_custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExerciseCorrectAnswer extends StatefulWidget {
  const ExerciseCorrectAnswer({Key? key}) : super(key: key);

  @override
  State<ExerciseCorrectAnswer> createState() => _ExerciseCorrectAnswerState();
}

class _ExerciseCorrectAnswerState extends State<ExerciseCorrectAnswer> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    // handling errors! QuizCubit inGameWords cannot be null!
    List<Word>? min3wordsInGame = context.read<WordsCubit>().state.words;
    if (min3wordsInGame.isNotEmpty && min3wordsInGame.length >= 3) {
      // .getRange(0, 3) need to have at least 3 items in list!
      min3wordsInGame = (min3wordsInGame.toList()..shuffle()).getRange(0, 3).toList();
    }
    return BlocProvider(
      create: (context) => QuizCubit(
        context.read<WordsCubit>(),
        min3wordsInGame ?? <Word>[],
        // (context.read<WordsCubit>().state.words.toList()..shuffle()).getRange(0, 3).toList(),
      ),
      child: BlocConsumer<QuizCubit, QuizState>(
        listener: (context, state) {
          if (state.notPlayedIds.length < 3 && state.isLocked) {
            showSnack(context, 'You have played all your words');
          }
          // if (state.inGameWords.isEmpty || state.successId == -1) {
          //   showSnack(context, 'Sorry, the Quiz could not be started!');
          // }
        },
        builder: (context, state) {
          QuizState st = context.read<QuizCubit>().state;
          // protection in case he user has less than 3 saved words in DB!
          if (state.inGameWords.isEmpty || state.inGameWords.length < 3) {
            final int number  = state.inGameWords.isNotEmpty ? state.inGameWords.length : 0;
            return _showLessThen3wordsNotification(number);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                QuizHeader(
                    title: 'QUIZ',
                    didUserGuess: st.didUserGuess,
                    isLocked: st.isLocked,
                    total: st.gamePoints,
                    score: st.roundPoints),
                Flexible(
                    fit: FlexFit.loose,
                    flex: 3,
                    child: PageView.builder(
                        itemCount: 2,
                        controller: _controller,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          // final _question = 'questions[index]';
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    const Text('Select the correct answer',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                                    const SizedBox(height: 10),
                                    QuestionWidget(question: st.question.text()),
                                    ...st.options
                                        .map((option) => OptionWidget(
                                              key: Key(option.text),
                                              onTapedOption: (option) => context.read<QuizCubit>().onSelect(option),
                                              option: option,
                                            ))
                                        .toList(),
                                    const Divider(thickness: 1, color: Colors.grey),
                                    QuestionClueWidget(
                                        // onChanged: (bool isExpending) =>
                                        //     context.read<QuizCubit>().onClueDemand(isExpending),
                                        onChanged: () => context.read<QuizCubit>().onClueDemand(),
                                        isExpended: context.read<QuizCubit>().state.isClueOpen,
                                        clue: st.question.clue())
                                  ],
                                ),
                              ),
                            ),
                          ]);
                        })),
                Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildElevatedBtn(
                          text: 'Quit',
                          onPressed: () => context.router.pop(),
                        ),
                        buildElevatedBtn(
                          text: 'Next',
                          onPressed: (st.notPlayedIds.length >= 3 && (st.isLocked || st.didUserGuess))
                              ? () => context.read<QuizCubit>().onNext()
                              : null,
                        ),
                      ],
                    )),
                Center(
                  child: (st.notPlayedIds.length < 3 && st.isLocked)
                      ? const Text(
                          'You have played all your words',
                          style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                        )
                      : null,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Center _showLessThen3wordsNotification(int addedWords) {
    const String untilNow = 'Until now you have been added: ';
    const String toPlay = '\nThen you can play.';
    final int haveToAdd = 3 - addedWords;
    return Center(
        child: Text(
          '$untilNow $addedWords words or sentences.\n You have to add at least $haveToAdd more $toPlay',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, height: 2.0, color: Colors.red),
    ));
  }

  ElevatedButton buildElevatedBtn({
    required String text,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
        key: Key(text),
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(onPressed == null ? Colors.blueGrey : Colors.blue),
          padding: MaterialStateProperty.all(const EdgeInsets.all(2)),
        ),
        child: Text(text));
  }
}
