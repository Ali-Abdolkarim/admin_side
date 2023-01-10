import 'dart:developer';

import 'package:admin_side/constants.dart';
import 'package:admin_side/views/add_question.dart';
import 'package:admin_side/views/widgets/buttons.dart';
import 'package:admin_side/views/widgets/c_texts.dart';
import 'package:admin_side/views/widgets/fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamPage extends StatefulWidget {
  final String id;
  const ExamPage(this.id, {super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  bool loading = true;
  List<QueryDocumentSnapshot> questions = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _formState = GlobalKey<FormState>();
  var data;
  DateTime? date;
  var dateText;
  var timeText;
  final _durationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    log(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    DocumentSnapshot? document;
    db.collection('exams').doc(widget.id).snapshots().listen((event) async {
      questions.removeRange(0, questions.length);
      questions = [];
      if (event.data() != null) {
        log(event.data().toString());
        if (_durationController.text.isEmpty) {
          if (event.data()![Texts.DURATION] != null) {
            _durationController.text = event.data()![Texts.DURATION].toString();
          } else {
            _durationController.text = '0';
          }
        }
        if (event.data()![Texts.DATE] != null) {
          date = DateTime.fromMillisecondsSinceEpoch(event.data()![Texts.DATE]);
          dateText = '${date!.year}-${date!.month}-${date!.day}';
        }
        data = event.data();
        // if (data['questions'] != null) {
        //   documents = await db.collection('questions').get();
        //   for (var element in documents!.docs) {
        //     if (data['questions'].contains(element.id) &&
        //         !questions.contains(element)) {
        //       questions.add(element);
        //     }
        //   }
        //   if (mounted) {
        //     setState(() {});
        //   }
        // }
      }
    });

    db
        .collection(Texts.QUESTIONS)
        .where(Texts.EXAM_ID, isEqualTo: widget.id)
        .snapshots()
        .listen((event) async {
      questions.clear();
      for (var element in event.docs) {
        log('-->>${element.data()}');
        if (!questions.contains(element)) {
          questions.add(element);
        }
      }
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void changeExamDuration(String? duration) async {
    if (_formState.currentState != null &&
        _formState.currentState!.validate()) {
      if (duration != null && duration.isNotEmpty) {
        await db
            .collection(Texts.EXAMS)
            .doc(widget.id)
            .update({Texts.DURATION: int.parse(duration)});
      }
    }
  }

  void showDateDialog() async {
    date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (date != null) {
      dateText = '${date!.year}-${date!.month}-${date!.day}';
      await db
          .collection(Texts.EXAMS)
          .doc(widget.id)
          .update({Texts.DATE: date!.millisecondsSinceEpoch});
    }
    setState(() {});
  }

  void showTimeDialog() async {
    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (time != null && date != null) {
      timeText = '${time.hour}:${time.minute}';
      log(time.toString());
      date = DateTime(date!.year, date!.month, date!.day);
      date = date!.add(Duration(hours: time.hour));
      date = date!.add(Duration(minutes: time.minute));
      log('-->>>>>>>> ${date!.millisecondsSinceEpoch}');
      await db
          .collection(Texts.EXAMS)
          .doc(widget.id)
          .update({Texts.DATE: date!.millisecondsSinceEpoch});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackButton(),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                      child: CText('Date of Exam'),
                    ),
                    Container(
                      width: size.width,
                      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                      child: Row(
                        children: [
                          Expanded(
                              child: CText(dateText ?? 'Please select a date')),
                          Expanded(
                              child: SimpleButton(
                            'Set Date',
                            action: showDateDialog,
                          )),
                        ],
                      ),
                    ),
                    if (dateText != null)
                      Container(
                        width: size.width,
                        margin:
                            const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                        child: Row(
                          children: [
                            Expanded(
                                child: CText(
                                    timeText ?? 'Please select the time')),
                            Expanded(
                                child: SimpleButton(
                              'Set Time',
                              action: showTimeDialog,
                            )),
                          ],
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 0, 8),
                      child: CText(
                        'Exam Duration,\nPlease input in terms of minutes.',
                        align: TextAlign.start,
                      ),
                    ),
                    Form(
                      key: _formState,
                      child: Container(
                        margin:
                            const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 10),
                        child: SimpleFormInput(
                          hintText: 'Duration',
                          controller: _durationController,
                          prefixIcon: const Icon(Icons.timelapse),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter text';
                            } else if (!value.isNum) {
                              return 'input text should be number';
                            }
                            return null;
                          },
                          onChanged: changeExamDuration,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                      child: CText('Questions'),
                    ),
                    ...questions
                        .map((e) => Card(
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  8, 4, 8, 4),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => AddQuestionPage(
                                        widget.id,
                                        true,
                                        questionId: e.id,
                                      ));
                                },
                                child: Container(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 8, 8, 8),
                                  alignment: Alignment.center,
                                  width: size.width,
                                  height: size.height * .1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CText(
                                          (e.data() as Map?)!['question']
                                              .toString(),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => deleteItem(e),
                                        child: Container(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(4, 4, 4, 4),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList()
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddQuestionPage(widget.id, false),
            ));
          }),
    );
  }

  deleteItem(QueryDocumentSnapshot<Object?> e) async {
    var temp = data['questions'] as List;
    temp.remove(e.id);
    await db.collection('exams').doc(widget.id).update({'questions': temp});
    await db.collection('questions').doc(e.id).delete();
    log('we are here');
  }
}
