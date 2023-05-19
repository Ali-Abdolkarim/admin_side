import 'dart:developer';

import 'package:admin_side/views/widgets/buttons.dart';
import 'package:admin_side/views/widgets/c_texts.dart';
import 'package:admin_side/views/widgets/fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  FirebaseFirestore? db;
  bool loading = false;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  var _formState = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
  }

  void addUser() async {
    if (_formState.currentState!.validate()) {
      log('message');
      setState(() {
        loading = true;
      });
      await db!.collection('users').add({
        'username': usernameController.text.trim(),
        'password': passwordController.text.trim()
      });
      usernameController.clear();
      passwordController.clear();
      Get.showSnackbar(const GetSnackBar(
        isDismissible: true,
        duration: Duration(seconds: 2),
        messageText: Center(
          child: CText(
            'Success',
            color: Colors.white,
          ),
        ),
      ));
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formState,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BackButton(),
                            Center(
                              child: Image.asset(
                                'assets/add_user.png',
                                height: size.height * 0.2,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  8, 20, 8, 8),
                              child: SimpleFormInput(
                                hintText: 'Username',
                                prefixIcon: const Icon(Icons.person),
                                controller: usernameController,
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
                            Container(
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 8, 8),
                              child: SimpleFormInput(
                                hintText: 'Password',
                                prefixIcon: const Icon(Icons.visibility),
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  } else if (value.length < 6) {
                                    return 'at least enter 6 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                      child: SimpleButton(
                        'Add User',
                        action: addUser,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
