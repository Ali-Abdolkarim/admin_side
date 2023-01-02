import 'dart:developer';

import 'package:admin_side/views/exam_page.dart';
import 'package:admin_side/views/widgets/buttons.dart';
import 'package:admin_side/views/widgets/c_texts.dart';
import 'package:admin_side/views/widgets/fields.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ExamListPage extends StatefulWidget {
  const ExamListPage({super.key});

  @override
  State<ExamListPage> createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage> {
  bool loading = true;
  FirebaseFirestore db = FirebaseFirestore.instance;
  // List<QueryDocumentSnapshot>? data;
  final _examController = TextEditingController();
  final _formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // _loadData();
  }

  // void _loadData() async {
  //   if (mounted) {
  //     setState(() {
  //       loading = true;
  //     });
  //   }
  //   db.collection('exams').snapshots().listen((event) {
  //     data = event.docs;

  //     log('data updated -> $data');
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   });
  //   if (mounted) {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: db.collection('exams').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // if (snapshot.connectionState != ConnectionState.done) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackButton(),
                  if (snapshot.data != null)
                    ...snapshot.data!.docs.map((e) {
                      var currenitem = (e.data() as Map?);
                      return Card(
                        margin:
                            const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ExamPage(e.id));
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
                                    currenitem!['title'].toString(),
                                  ),
                                ),
                                AnimatedToggleSwitch<bool>.dual(
                                  current: currenitem['enabled'],
                                  first: true,
                                  second: false,
                                  dif: 50.0,
                                  borderColor: Colors.transparent,
                                  borderWidth: 5.0,
                                  height: 55,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1.5),
                                    ),
                                  ],
                                  onChanged: (value) async {
                                    log(value.toString() + ' ${e.id}');
                                    await db
                                        .collection('exams')
                                        .doc(e.id)
                                        .update({'enabled': value});
                                    log((await db
                                            .collection('exams')
                                            .doc(e.id)
                                            .get())
                                        .data()
                                        .toString());
                                    return value;
                                  },
                                  colorBuilder: (b) =>
                                      b ? Colors.green : Colors.red,
                                  iconBuilder: (value) => value
                                      ? const Icon(Icons.done)
                                      : const Icon(Icons.cancel),
                                  textBuilder: (value) => value
                                      ? const Center(child: Text('Enabled'))
                                      : const Center(child: Text('Disabled')),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          showTitleDialog(context);
        },
      ),
    );
  }

  void showTitleDialog(BuildContext context) async {
    Get.defaultDialog(
      title: 'Exam Title',
      confirm: SimpleButton(
        'Add',
        height: 45,
        action: () async {
          Get.back();
          setState(() {
            loading = true;
          });
          var temp = await db.collection('exams').add({
            'title': _examController.text,
            'enabled': false,
          });
          log(temp.id);

          _examController.clear();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ExamPage(temp.id),
          ));
          setState(() {
            loading = false;
          });
        },
      ),
      cancel: SimpleButton(
        'Cancel',
        height: 45,
        action: () {
          Get.back();
          _examController.text = '';
        },
      ),
      content: Form(
        key: _formState,
        child: SimpleFormInput(
          validator: (value) {
            if (value!.trim().isEmpty) {
              return 'can\'t be empty';
            }
            return null;
          },
          hintText: 'Exam Title',
          controller: _examController,
        ),
      ),
    );
  }
}
