import 'package:admin_side/views/widgets/buttons.dart';
import 'package:admin_side/views/widgets/c_texts.dart';
import 'package:admin_side/views/widgets/fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddQuestionPage extends StatefulWidget {
  final String id;
  final String? questionId;
  final bool update;
  const AddQuestionPage(this.id, this.update, {super.key, this.questionId});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  bool loading = true;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var answers = [];
  final _controller = TextEditingController();
  final _answerController = TextEditingController();

  final _formState = GlobalKey<FormState>();
  final _answerFormState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    var data;
    DocumentSnapshot? response;
    var parseResponse;
    db
        .collection('questions')
        .doc(widget.questionId)
        .snapshots()
        .listen((event) async {
      data = event.data();

      if (data != null && data['question'] != null) {
        _controller.text = data['question'];
      }
      if (data != null && data['answers'] != null) {
        response = await db.collection('answers').doc(data['answers']).get();
        parseResponse = response!.data() as Map?;
        if (parseResponse != null && parseResponse!['answers'] != null) {
          for (var element in parseResponse!['answers']) {
            answers.add(element);
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
      _answerController.text = '';
      Get.back();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void addQuestion() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // var temp = answers.map((e) => {'${answers.indexOf(e)}': e}).toList();
    if (_formState.currentState!.validate()) {
      var answerss = [];
      for (var e in answers) {
        answerss.add(e);
      }
      DocumentReference answerRef = await db.collection('answers').add({});
      await answerRef.set({'answers': answerss});

      DocumentReference questionRef = await db
          .collection('questions')
          .add({'question': _controller.text.trim(), 'answers': answerRef.id});

      DocumentSnapshot examsSnapshot =
          await db.collection('exams').doc(widget.id).get();
      var data = examsSnapshot.data() as Map?;
      var questions = [];

      if (data != null && data['questions'] != null) {
        questions.addAll(data['questions']);
      }
      questions.add(questionRef.id);

      await db
          .collection('exams')
          .doc(widget.id)
          .update({'questions': questions});
      Navigator.pop(context);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void updateQuestion() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // var temp = answers.map((e) => {'${answers.indexOf(e)}': e}).toList();
    if (_formState.currentState!.validate()) {
      var answerss = [];
      for (var e in answers) {
        answerss.add(e);
      }
      DocumentReference answerRef = await db.collection('answers').add({});
      await answerRef.set({'answers': answerss});

      await db
          .collection('questions')
          .doc(widget.questionId)
          .set({'question': _controller.text.trim(), 'answers': answerRef.id});
      Navigator.pop(context);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
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
              stream: db.collection('questions').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // if (snapshot.connectionState == ConnectionState.active) {
                //   return const Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                return Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formState,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const BackButton(),
                              Container(
                                margin: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 0),
                                child: SimpleFormInput(
                                  hintText: 'Question',
                                  prefixIcon: const Icon(Icons.person),
                                  controller: _controller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    } else if (value.length < 2) {
                                      return 'at least enter 3 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (answers.isNotEmpty)
                                Container(
                                  margin: const EdgeInsetsDirectional.fromSTEB(
                                      0, 5, 0, 0),
                                  child: const CText(
                                    'Answers: ',
                                  ),
                                ),
                              ...answers
                                  .map(
                                    (e) => Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 8, 0, 0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CText(
                                              '- $e',
                                              align: TextAlign.start,
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
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red),
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(4, 4, 4, 4),
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
                                margin: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 20),
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
                    Container(
                      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                      child: SimpleButton(
                        widget.update ? 'Update Question' : 'Add Question',
                        action: widget.update ? updateQuestion : addQuestion,
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
