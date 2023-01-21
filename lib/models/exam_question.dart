import 'package:json_annotation/json_annotation.dart';

part 'exam_question.g.dart';

@JsonSerializable()
class ExamQuestion {
  @JsonKey(name: 'correct_answer')
  List<bool>? correctAnswer;
  @JsonKey(name: 'answers_link')
  String? answersLink;
  @JsonKey(name: 'extra_point')
  String? extraPoint;
  @JsonKey(name: 'exam_id')
  String? examId;
  String? question;
  AnswerItemModel? answerItemModel;
  List<bool>? selectedAnswers = [];

//change the to json to   'answerItemModel': _$AnswerItemModelToJson(instance.answerItemModel!),
//as it throws an exception

  ExamQuestion({
    this.question,
    this.answerItemModel,
    this.correctAnswer,
    this.examId,
    this.extraPoint,
    this.answersLink,
    this.selectedAnswers,
  });

  factory ExamQuestion.fromJson(Map<String, dynamic> json) =>
      _$ExamQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$ExamQuestionToJson(this);
}

// @JsonSerializable()
// class Answers {
//   int? id;
//   @JsonKey(name: 'school_exam_question_id')
//   int? schoolExamQuestionId;
//   String? answer;

//   Answers({this.id, this.schoolExamQuestionId, this.answer});

//   factory Answers.fromJson(Map<String, dynamic> json) =>
//       _$AnswersFromJson(json);

//   Map<String, dynamic> toJson() => _$AnswersToJson(this);
// }

@JsonSerializable()
class AnswerItemModel {
  List<String> answers;
  @JsonKey(name: 'question_id')
  String questionId;

  AnswerItemModel(
    this.questionId,
    this.answers,
  );

  factory AnswerItemModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerItemModelToJson(this);
}
