import 'package:admin_side/constants.dart';
import 'package:admin_side/views/widgets/buttons.dart';
import 'package:admin_side/views/widgets/c_texts.dart';
import 'package:admin_side/views/widgets/fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddQuestionPage extends StatefulWidget {
  final String examId;
  final String? questionId;
  final bool update;
  const AddQuestionPage(this.examId, this.update, {super.key, this.questionId});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  bool loading = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var answers = [];
  final _controller = TextEditingController();
  final _answerController = TextEditingController();
  final _extraPointontroller = TextEditingController(text: '0');

  final _formState = GlobalKey<FormState>();
  final _answerFormState = GlobalKey<FormState>();
  List<dynamic> _correctAnswers = [];
  var data;
  @override
  void initState() {
    super.initState();
    if (widget.update) {
      _loadData();
    }
  }

  void _loadData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    DocumentSnapshot? response;
    var parseResponse;
    db
        .collection(Texts.QUESTIONS)
        .doc(widget.questionId)
        .snapshots()
        .listen((event) async {
      data = event.data();
      if (data != null) {
        if (data[Texts.CORRECT_ANSWER] != null) {
          _correctAnswers = data[Texts.CORRECT_ANSWER];
        }
        if (data[Texts.EXTRA_POINT] != null) {
          _extraPointontroller.text = data[Texts.EXTRA_POINT];
        }
        if (data[Texts.QUESTION] != null) {
          _controller.text = data[Texts.QUESTION];
        }
        if (data[Texts.ANSWERS] != null) {
          response =
              await db.collection(Texts.ANSWERS).doc(data[Texts.ANSWERS]).get();
          parseResponse = response!.data() as Map?;
          if (parseResponse != null && parseResponse![Texts.ANSWERS] != null) {
            for (var element in parseResponse![Texts.ANSWERS]) {
              answers.add(element);
            }
          }
        }
      }
      if (mounted) {
        if (mounted) {
          setState(() {});
        }
      }
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void addAnswer() {
    if (_answerFormState.currentState != null &&
        _answerFormState.currentState!.validate()) {
      answers.add(_answerController.text.trim());
      _correctAnswers.add(false);
      _answerController.text = '';
      Get.back();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void addQuestion() async {
    // var temp = answers.map((e) => {'${answers.indexOf(e)}': e}).toList();
    if (_formState.currentState!.validate()) {
      // if (_correctAnswers == null) {
      //   Get.defaultDialog(
      //       radius: 6,
      //       cancel: SimpleButton(
      //         'Cancel',
      //         action: () => Get.back(),
      //         borderRadius: 6,
      //       ),
      //       content: const CText(
      //           'Please select an answer by tapping on one answer.'));
      //   return;
      // }
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
      var answerss = [];
      for (var e in answers) {
        answerss.add(e);
      }
      DocumentReference answerRef = await db.collection(Texts.ANSWERS).add({});
      await answerRef.set({Texts.ANSWERS: answerss});

      DocumentReference questionRef = await db.collection(Texts.QUESTIONS).add({
        Texts.QUESTION: _controller.text.trim(),
        Texts.ANSWERS: answerRef.id,
        Texts.CORRECT_ANSWER: _correctAnswers,
        Texts.EXAM_ID: widget.examId,
        Texts.EXTRA_POINT: _extraPointontroller.text.trim(),
      });
      await answerRef.update({Texts.QUESTION_ID: questionRef.id});

      DocumentSnapshot examsSnapshot =
          await db.collection(Texts.EXAMS).doc(widget.examId).get();
      var data = examsSnapshot.data() as Map?;
      var questions = [];

      if (data != null && data[Texts.QUESTIONS] != null) {
        questions.addAll(data[Texts.QUESTIONS]);
      }
      questions.add(questionRef.id);

      await db
          .collection(Texts.EXAMS)
          .doc(widget.examId)
          .update({Texts.QUESTIONS: questions});
      Navigator.pop(context);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void updateQuestion() async {
    // var temp = answers.map((e) => {'${answers.indexOf(e)}': e}).toList();
    if (_formState.currentState!.validate()) {
      // if (_correctAnswers == null) {
      //   Get.defaultDialog(
      //       radius: 6,
      //       cancel: SimpleButton(
      //         'Cancel',
      //         action: () => Get.back(),
      //         borderRadius: 6,
      //       ),
      //       content: const CText(
      //           'Please select an answer by tapping on one answer.'));
      //   return;
      // }
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
      var answerss = [];
      for (var e in answers) {
        answerss.add(e);
      }
      await db.collection(Texts.ANSWERS).doc(data[Texts.ANSWERS]).update({
        Texts.ANSWERS: answerss,
        Texts.QUESTION_ID: widget.questionId,
      });

      await db.collection(Texts.QUESTIONS).doc(widget.questionId).update({
        Texts.QUESTION: _controller.text.trim(),
        Texts.CORRECT_ANSWER: _correctAnswers,
        Texts.EXTRA_POINT: _extraPointontroller.text.trim(),
        Texts.EXAM_ID: widget.examId,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: db.collection(Texts.QUESTIONS).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // if (snapshot.connectionState == ConnectionState.active) {
                //   return const Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                return loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formState,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8, 0, 8, 0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const BackButton(),
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 8),
                                        child: CText(
                                          'Question',
                                          align: TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsetsDirectional
                                            .fromSTEB(0, 8, 0, 0),
                                        child: SimpleFormInput(
                                          hintText: 'Question',
                                          prefixIcon:
                                              const Icon(Icons.question_mark),
                                          controller: _controller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            } else if (value.length < 2) {
                                              return 'at least enter 3 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 24, 0, 8),
                                        child: CText(
                                          'Please input the Extra Point, in case all answers were correct',
                                          align: TextAlign.start,
                                        ),
                                      ),
                                      SimpleFormInput(
                                        hintText: 'Extra Point',
                                        prefixIcon: const Icon(Icons.add_task),
                                        controller: _extraPointontroller,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          } else if (!value.isNum) {
                                            return 'Please enter Number';
                                          }
                                          return null;
                                        },
                                      ),
                                      if (answers.isNotEmpty)
                                        Container(
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(0, 5, 0, 0),
                                          child: const CText(
                                            'Answers: ',
                                          ),
                                        ),
                                      ...answers
                                          .map(
                                            (e) => Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // checking if correct answers contain the selected answer
                                                        _correctAnswers[answers
                                                                .indexOf(e)] =
                                                            !_correctAnswers[
                                                                answers.indexOf(
                                                                    e)];
                                                        setState(() {});
                                                      },
                                                      child: CText(
                                                        '- $e',
                                                        align: TextAlign.start,
                                                      ),
                                                    ),
                                                  ),
                                                  if (_correctAnswers
                                                          .isNotEmpty &&
                                                      _correctAnswers[
                                                          answers.indexOf(e)])
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.green),
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              4, 4, 4, 4),
                                                      margin:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              4, 0, 4, 0),
                                                      child: const Icon(
                                                        Icons.done,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (mounted) {
                                                        setState(() {
                                                          answers.remove(e);
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.red),
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              4, 4, 4, 4),
                                                      child: const Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      Container(
                                        margin: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 0, 20),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.defaultDialog(
                                              title: 'Add Answer',
                                              confirm: SimpleButton(
                                                'Add',
                                                height: 45,
                                                action: () {
                                                  addAnswer();
                                                },
                                              ),
                                              cancel: SimpleButton(
                                                'Cancel',
                                                height: 45,
                                                action: () {
                                                  Get.back();
                                                  _answerController.text = '';
                                                },
                                              ),
                                              content: Form(
                                                key: _answerFormState,
                                                child: SimpleFormInput(
                                                  validator: (value) {
                                                    if (value!.trim().isEmpty) {
                                                      return 'can\'t be empty';
                                                    }
                                                    return null;
                                                  },
                                                  hintText: 'Answer',
                                                  controller: _answerController,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const CText(
                                            'Add Answer',
                                            color: Colors.lightBlue,
                                            underLine: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                8, 8, 8, 8),
                            child: SimpleButton(
                              widget.update
                                  ? 'Update Question'
                                  : 'Add Question',
                              action:
                                  widget.update ? updateQuestion : addQuestion,
                            ),
                          ),
                        ],
                      );
              }),
        ),
      ),
    );
  }
}
