import 'package:admin_side/constants.dart';
import 'package:admin_side/views/add_user_page.dart';
import 'package:admin_side/views/exam_list_page.dart';
import 'package:admin_side/views/exam_taken_page.dart';
import 'package:admin_side/views/login_view.dart';
import 'package:admin_side/views/widgets/buttons.dart';
import 'package:admin_side/views/widgets/c_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  GetStorage().remove(Texts.USERNAME);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                      (route) => false);
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CText('Logout'),
                      Container(
                          margin:
                              const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: const Icon(Icons.logout)),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  width: size.width,
                  height: size.height * 0.2,
                  margin: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  padding: const EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
                  color: const Color.fromARGB(255, 213, 44, 35),
                  child: Image.asset(
                    'assets/ul_logo.png',
                    height: size.height * 0.2,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
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
            ],
          ),
        ),
      ),
    );
  }
}
