import 'package:admin_side/constants.dart';
import 'package:admin_side/views/show_exam_result_page.dart';
import 'package:admin_side/views/widgets/c_texts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ExamTakenPage extends StatefulWidget {
  const ExamTakenPage({super.key});

  @override
  State<ExamTakenPage> createState() => _ExamTakenPageState();
}

class _ExamTakenPageState extends State<ExamTakenPage> {
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
  //   db.collection( Texts.EXAMS ).snapshots().listen((event) {
  //     data = event.docs;

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
          stream: db.collection(Texts.EXAMS_TAKEN).snapshots(),
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
                            Get.to(() => ShowExamResultPage(
                                accentColor:
                                    const Color.fromARGB(255, 213, 44, 35),
                                subject: currenitem[Texts.TITLE],
                                examId: currenitem[Texts.EXAM_ID],
                                examTakenId: e.id));
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
                                  child:
                                      CText(currenitem![Texts.USERNAME] ?? ''),
                                ),
                                Expanded(
                                  child: CText(
                                    currenitem[Texts.TITLE].toString(),
                                  ),
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
    );
  }
}
