import 'dart:developer';

import 'package:admin_side/views/add_question.dart';
import 'package:admin_side/views/widgets/c_texts.dart';
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
  var data;

  @override
  void initState() {
    super.initState();
    log(widget.id);
    _loadData();
  }

  void _loadData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    QuerySnapshot? documents;
    db.collection('exams').doc(widget.id).snapshots().listen((event) async {
      questions.removeRange(0, questions.length);
      data = event.data();
      if (data != null && data['questions'] != null) {
        documents = await db.collection('questions').get();
        for (var element in documents!.docs) {
          if (data['questions'].contains(element.id) &&
              !questions.contains(element)) {
            questions.add(element);
          }
        }
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
