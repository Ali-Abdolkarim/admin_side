import 'package:admin_side/views/add_user_page.dart';
import 'package:admin_side/views/exam_list_page.dart';
import 'package:admin_side/views/exam_taken_page.dart';
import 'package:admin_side/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
              child: SimpleButton(
                'Add User',
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddUserPage(),
                  ));
                },
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
              child: SimpleButton(
                'Exams Page',
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ExamListPage(),
                  ));
                },
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
              child: SimpleButton(
                'Exams Taken Page',
                action: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ExamTakenPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
