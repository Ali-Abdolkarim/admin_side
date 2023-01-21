import 'package:admin_side/models/exam_question.dart';
import 'package:admin_side/utils/read_svg.dart';
import 'package:admin_side/utils/utilities.dart';
import 'package:admin_side/views/widgets/buttons.dart';
import 'package:admin_side/views/widgets/c_texts.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:circular_countdown_timer/countdown_text_format.dart';
import 'package:flutter/material.dart';

class QuizInfoCard extends StatelessWidget {
  final List<QuizInfoItem>? items;
  final Color accentColor;
  final String icon;
  final int timeRemaining;
  final String? againText;
  final int totalQuestions;
  final int questionsAnswered;
  final String? title;
  final int initialTime;
  final ActionP? timeFinished;
  final bool? isFinished;
  const QuizInfoCard({
    Key? key,
    this.items,
    required this.accentColor,
    required this.icon,
    required this.timeRemaining,
    required this.initialTime,
    this.againText,
    this.title,
    this.timeFinished,
    this.isFinished,
    required this.questionsAnswered,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert((timeRemaining != null) ||
        (timeRemaining == null && againText != null));

    var size = MediaQuery.of(context).size;
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 10, 8),
        child: Column(
          children: [
            Row(
              children: [
                if (items != null)
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            CText(
                              title!,
                              sizee: 14,
                              align: TextAlign.start,
                              padding:
                                  const EdgeInsetsDirectional.only(bottom: 4),
                            ),
                          ...items!,
                        ]),
                  ),
                (isFinished ?? false)
                    ? const Center()
                    : Container(
                        constraints: BoxConstraints(minWidth: size.width * .2),
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(6, 18, 6, 18),
                        margin: const EdgeInsetsDirectional.only(start: 12),
                        decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          children: [
                            // ReadSVG.read(icon, color: Colors.deepOrange, size: 30),
                            // CText(
                            //   againText ??
                            //       '${timeRemaining! ~/ 3600}:${(timeRemaining! ~/ 60) % 60}:${timeRemaining! % 60}',
                            //   padding: const EdgeInsets.only(top: 4),
                            //   sizee: 14,
                            //   color: Colors.white,
                            // )
                            CircularCountDownTimer(
                              duration: timeRemaining,
                              controller: CountDownController(),
                              initialDuration: initialTime,
                              width: 60,
                              height: 60,
                              ringColor: Colors.grey[300]!,
                              ringGradient: null,
                              fillColor: (isFinished ?? false)
                                  ? Colors.transparent
                                  : Colors.purpleAccent[100]!,
                              fillGradient: null,
                              backgroundColor: Colors.purple[500],
                              backgroundGradient: null,
                              strokeWidth: 8.0,
                              strokeCap: StrokeCap.round,
                              textStyle: const TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textFormat: CountdownTextFormat.HH_MM_SS,
                              isReverse: true,
                              isReverseAnimation: false,
                              isTimerTextShown: true,
                              autoStart: true,
                              onStart: () {
                                debugPrint('Countdown Started');
                              },
                              onComplete: () {
                                if (timeFinished != null) {
                                  timeFinished!();
                                }
                              },
                              onChange: (String timeStamp) {
                                debugPrint('Countdown Changed $timeStamp');
                              },
                              timeFormatterFunction:
                                  (defaultFormatterFunction, duration) {
                                // return '${time.hour}:${time.minute}:${time.second}';
                                if (isFinished ?? false) {
                                  return 'Finished';
                                }
                                return Function.apply(
                                    defaultFormatterFunction, [duration]);
                              },
                            ),
                          ],
                        ),
                      )
              ],
            ),
            Container(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
              child: Row(
                children: [
                  // Expanded(
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(5),
                  //     child: LinearProgressIndicator(
                  //       backgroundColor: CustomColors.lightGreyColor,
                  //       color: accentColor,
                  //       value: questionsAnswered / totalQuestions,
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //   child: LinearPercentIndicator(
                  //     // width: 170.0,
                  //     animation: true,
                  //     animationDuration: 400,
                  //     lineHeight: 20.0,
                  //     animateFromLastPercent: true,
                  //     percent: questionsAnswered / totalQuestions,
                  //     backgroundColor: Colors
                  //         .lightBlue, // CustomColors.bLightAMediumGreyColor,
                  //     barRadius: const Radius.circular(8),
                  //     isRTL: true,
                  //     center: CText(
                  //       '${((questionsAnswered / totalQuestions) * 100).toStringAsFixed(0)}%',
                  //       sizee: 14,
                  //     ),
                  //     progressColor: Colors.orange, // CustomColors.orangeColor,
                  //   ),
                  // ),
                  // CText(
                  //   '$questionsAnswered/$totalQuestions',
                  //   sizee: 14,
                  //   padding: const EdgeInsetsDirectional.only(start: 16),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizInfoItem extends StatelessWidget {
  final String name;
  final String description;
  final bool? showLine;

  const QuizInfoItem(
    this.name,
    this.description, {
    this.showLine,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8, top: 4),
          child: Row(
            children: [
              CText(
                name,
                sizee: 14,
                padding: const EdgeInsetsDirectional.only(end: 12),
              ),
              CText(
                description,
                sizee: 14,

                color: Colors.grey[700], //.darkGreyColor,
              ),
            ],
          ),
        ),
        if (showLine ?? true)
          const Divider(
            height: 0,
            thickness: 1,
          )
      ],
    );
  }
}

class QuestionCard extends StatefulWidget {
  final ExamQuestion question;
  final EdgeInsetsGeometry? padding;
  final Color accentColor;
  final bool showAnswer;
  final ActionRVII? updateAnswerAction;
  final int questionIndex;
  final TextDirection? textDirection;
  final ActionP? resultAction;

  const QuestionCard({
    Key? key,
    required this.question,
    this.padding,
    required this.accentColor,
    required this.showAnswer,
    this.updateAnswerAction,
    this.textDirection,
    required this.questionIndex,
    required this.resultAction,
  }) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? selectedItem;
  var answers = [];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // log(widget.showAnswer.toString());
    // log(widget.showAnswer.toString());
    answers = widget.question.answerItemModel!.answers.map((e) {
      return AnswerItemCard(
        answer: e,
        // answerType: widget.question.answersType ?? 0,
        action: widget.showAnswer
            ? () {}
            : () {
                setState(() {
                  selectedItem = e;
                });
                //changed this one -------------------------------------------------------->
                widget.updateAnswerAction!(
                    widget.question.answerItemModel!.answers.indexOf(e));
              },
        isSelected: widget.question.selectedAnswers![
            widget.question.answerItemModel!.answers.indexOf(e)],
        isCorrect: widget.showAnswer &&
            widget.question.correctAnswer![
                    widget.question.answerItemModel!.answers.indexOf(e)] ==
                widget.question.selectedAnswers![
                    widget.question.answerItemModel!.answers.indexOf(e)],
        // &&
        // selectedItem!.answer == e.answer,
        accentColor: widget.accentColor,
        showAnswer: widget.showAnswer,
      );
    }).toList();

    return Directionality(
      textDirection: widget.textDirection ?? TextDirection.ltr,
      child: Container(
        margin: widget.padding ?? const EdgeInsetsDirectional.only(bottom: 8),
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  // widget.showAnswer
                  // ? selectedItem == null
                  //     ? Colors.grey
                  //     : widget.question
                  //             .correctAnswer![widget.question.answerItemModel!.answers.indexOf(e)]
                  //         ? Colors.green
                  //         : Colors.red
                  // :
                  widget.accentColor),
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: const EdgeInsets.only(bottom: 9),
              width: size.width,
              alignment: AlignmentDirectional.centerStart,
              decoration: BoxDecoration(
                color:
                    // widget.showAnswer
                    //     ? selectedItem == null
                    //         ? Colors.grey
                    //         : widget.question
                    //                 .correctAnswer![answers.indexOf(selectedItem)]
                    //             ? Colors.green
                    //             : Colors.red
                    //     :
                    widget.accentColor,
                borderRadius: const BorderRadiusDirectional.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: TwoElementFirstExpanded(
                // widget.question.questionType == 0
                // ?
                CText(
                  align: TextAlign.start,
                  widget.question.question ?? '',
                  color: widget.accentColor == Colors.pink
                      ? Colors.white
                      : widget.showAnswer
                          ? Colors.white
                          : Colors.black,
                  sizee: 14,
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                ),
                // : Html(
                //     data: widget.question.question ?? '',
                //   ),
                // widget.showAnswer && (widget.question.result) != null
                //     ? InkWell(
                //         onTap: widget.resultAction,
                //         child: const Padding(
                //           padding: EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
                //           child: Icon(
                //             Icons.fullscreen,
                //             color: Colors.white,
                //           ),
                //         ),
                //       )
                //     :
                const Center(),
              ),
            ),
            ...answers,
          ],
        ),
      ),
    );
  }
}

// class AnswerId extends Equatable {
//   final String answer;
//   final String id;
//   const AnswerId({required this.answer, required this.id});

//   @override
//   // TODO: implement props
//   List<Object?> get props => [answer, id];
// }

class AnswerItemCard extends StatelessWidget {
  final String answer;
  final EdgeInsetsGeometry? padding;
  final Color? rightAnswerColor;
  final Color? wrongAnswerColor;
  final bool isSelected;
  final bool isCorrect;
  final ActionP action;
  final Color? accentColor;
  final bool showAnswer;
  // final int answerType;
  const AnswerItemCard({
    Key? key,
    required this.answer,
    required this.action,
    this.padding,
    this.rightAnswerColor,
    this.wrongAnswerColor,
    required this.isSelected,
    this.accentColor,
    required this.isCorrect,
    required this.showAnswer,
    // required this.answerType,
  }) : super(key: key);
  void printItem() {
    print('name $answer');
    print('sel $isSelected');
    print('correct $isCorrect');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        margin: padding ?? const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 12, 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: showAnswer
                    ? isCorrect
                        ? Colors.green
                        : Colors.red
                    : isSelected
                        ? accentColor!
                        : Colors.grey),
            color: showAnswer
                ? isCorrect
                    ? Colors.white
                    : Colors.grey[300]
                : isSelected
                    ? Colors.white
                    : Colors.grey[300]),
        alignment: Alignment.center,
        child: TwoElementFirstExpanded(
          // answerType == 0
          //     ?
          CText(
            answer,
            color: showAnswer
                ? isCorrect
                    ? Colors.green
                    : Colors.red
                : isSelected
                    ? accentColor
                    : Colors.grey[700],
            sizee: 14,
            align: TextAlign.start,
          ),
          // : Html(data: answer),
          ReadSVG.read(
            isSelected ? 'tick_in_circle' : 'unselected_answer',
            color: showAnswer
                ? isCorrect
                    ? Colors.green
                    : Colors.red
                : isSelected
                    ? accentColor
                    : Colors.grey[700],
            size: 18,
          ),
        ),
      ),
    );
  }
}

class RowWithSeperatedItemsCard extends StatelessWidget {
  final List<Widget> items;
  final EdgeInsetsGeometry? padding;
  final bool? showDivider;
  var counter = 0;
  RowWithSeperatedItemsCard({
    Key? key,
    required this.items,
    this.padding,
    this.showDivider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: padding ?? EdgeInsets.zero,
      child: Row(
        children: items.map(
          (e) {
            counter++;
            return Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  e,
                  if (counter < items.length &&
                      showDivider != null &&
                      showDivider!)
                    Container(
                      height: size.height * 0.035,
                      width: 1,
                      color: Colors.grey,
                    )
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
