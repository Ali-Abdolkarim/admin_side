import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Texts {
  static const String QUESTIONS = 'questions';
  static const String QUESTION = 'question';
  static const String EXAMS = 'exams';
  static const String ANSWERS = 'answers';
  static const String CORRECT_ANSWER = 'correct_answer';
  static const String DATE = 'date';
  static const String TITLE = 'title';
  static const String ENABLED = 'enabled';
  static const String CODEE = 'code';
  static const String EXTRA_POINT = 'extra_point';
  static const String DURATION = 'duration';
  static const String EXAMS_TAKEN = 'exams_taken';
  static const String EXAM_ID = 'exam_id';
  static const String QUESTION_ID = 'question_id';
  static const String USERNAME = 'username';
  static const String SUBMITTED = 'submitted';
  static const String RESULT = 'result';
}

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.060,
      fontWeight: FontWeight.bold,
    );

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.030,
    );

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: Colors.grey, height: 1.5);

TextStyle kHaveAnAccountStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.black);

TextStyle kNormalStylel(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.black);

TextStyle kLoginOrSignUpTextStyle(
  Size size,
) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w500,
      color: Colors.red,
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);
