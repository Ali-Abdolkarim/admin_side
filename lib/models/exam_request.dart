import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exam_request.g.dart';

@JsonSerializable()
class ExamRequest extends Equatable {
  @JsonKey(name: 'school_exam_id')
  final String? schoolExamId;
  @JsonKey(name: 'school_subject_id')
  final String schoolSubjectId;
  @JsonKey(name: 'school_exam_part_id')
  final String? schoolPartId;
  @JsonKey(name: 'school_exam_section_id')
  final String? schoolSectionId;
  ExamRequest({
    this.schoolExamId,
    this.schoolPartId,
    this.schoolSectionId,
    required this.schoolSubjectId,
  });
  factory ExamRequest.fromJson(Map<String, dynamic> json) =>
      _$ExamRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ExamRequestToJson(this);

  @override
  List<Object?> get props =>
      [schoolExamId, schoolPartId, schoolSectionId, schoolSubjectId];
}
