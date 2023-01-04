import 'dart:developer';

import 'package:admin_side/views/home_page.dart';
import 'package:admin_side/views/widgets/buttons.dart';
import 'package:admin_side/views/widgets/c_texts.dart';
import 'package:admin_side/views/widgets/fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';

import '../constants.dart';
import '../controller/simple_ui_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  FirebaseFirestore? db;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  SimpleUIController simpleUIController = Get.put(SimpleUIController());
  GetStorage storage = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
  }

  void signIn() async {
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      var snapshot = await (db!
              .collection('admins')
              .where('name', isEqualTo: nameController.text.trim())
              .where('password', isEqualTo: passwordController.text.trim()))
          .get();
      for (var element in snapshot.docs) {
        log(element.data().toString());
      }
      if (snapshot.docs.isEmpty) {
        Get.defaultDialog(
          title: 'Error',
          content: const CText('Wrong Username/Password'),
          cancel: SimpleButton(
            'Cancel',
            action: () => Get.back(),
          ),
        );
      } else {
        await storage.write('name', nameController.text.trim());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SimpleUIController simpleUIController = Get.find<SimpleUIController>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size, simpleUIController);
            } else {
              return _buildSmallScreen(size, simpleUIController);
            }
          },
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Row(
      children: [
        // Expanded(
        //   flex: 4,
        //   child: RotatedBox(
        //     quarterTurns: 3,
        //     child: Lottie.asset(
        //       'assets/coin.json',
        //       height: size.height * 0.3,
        //       width: double.infinity,
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),
        // SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(
            size,
            simpleUIController,
          ),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: size.width > 600
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              size.width > 600
                  ? Container()
                  : Container(
                      width: size.width,
                      height: size.height * 0.2,
                      padding: const EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
                      color: const Color.fromARGB(255, 213, 44, 35),
                      child: Image.asset(
                        'assets/ul_logo.png',
                        height: size.height * 0.2,
                        fit: BoxFit.contain,
                      ),
                    ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Login',
                  style: kLoginTitleStyle(size),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// username or Gmail
                      TextFormField(
                        style: kTextFormFieldStyle(),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        controller: nameController,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          } else if (value.length < 4) {
                            return 'at least enter 4 characters';
                          } else if (value.length > 13) {
                            return 'maximum character is 13';
                          }
                          return null;
                        },
                      ),

                      SizedBox(
                        height: size.height * 0.02,
                      ),

                      /// password
                      Obx(
                        () => SimpleFormInput(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (value.length < 7) {
                              return 'at least enter 6 characters';
                            } else if (value.length > 13) {
                              return 'maximum character is 13';
                            }
                            return null;
                          },
                          prefixIcon: const Icon(Icons.lock_open),
                          suffixIcon: IconButton(
                            icon: Icon(
                              simpleUIController.isObscure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              simpleUIController.isObscureActive();
                            },
                          ),
                          hintText: 'Password',
                          controller: passwordController,

                          // )

                          //  TextFormField(
                          //   style: kTextFormFieldStyle(),
                          //   controller: passwordController,
                          //   obscureText: simpleUIController.isObscure.value,
                          //   decoration: InputDecoration(
                          //     prefixIcon: const Icon(Icons.lock_open),
                          //     suffixIcon: IconButton(
                          //       icon: Icon(
                          //         simpleUIController.isObscure.value
                          //             ? Icons.visibility
                          //             : Icons.visibility_off,
                          //       ),
                          //       onPressed: () {
                          //         simpleUIController.isObscureActive();
                          //       },
                          //     ),
                          //     hintText: 'Password',
                          //     border: const OutlineInputBorder(
                          //       borderRadius: BorderRadius.all(Radius.circular(15)),
                          //     ),
                          //   ),
                          //   // The validator receives the text that the user has entered.
                          //   validator: (value) {
                          //     // if (value == null || value.isEmpty) {
                          //     //   return 'Please enter some text';
                          //     // } else if (value.length < 7) {
                          //     //   return 'at least enter 6 characters';
                          //     // } else if (value.length > 13) {
                          //     //   return 'maximum character is 13';
                          //     // }
                          //     return null;
                          //   },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),

                      SizedBox(
                        height: size.height * 0.02,
                      ),

                      /// Login Button
                      SimpleButton(
                        'Login',
                        action: signIn,
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  // Login Button

}
