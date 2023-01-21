// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamRequest _$ExamRequestFromJson(Map<String, dynamic> json) => ExamRequest(
      schoolExamId: json['school_exam_id'] as String?,
      schoolPartId: json['school_exam_part_id'] as String?,
      schoolSectionId: json['school_exam_section_id'] as String?,
      schoolSubjectId: json['school_subject_id'] as String,
    );

Map<String, dynamic> _$ExamRequestToJson(ExamRequest instance) =>
    <String, dynamic>{
      'school_exam_id': instance.schoolExamId,
      'school_subject_id': instance.schoolSubjectId,
      'school_exam_part_id': instance.schoolPartId,
      'school_exam_section_id': instance.schoolSectionId,
    };
