// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamInfo _$ExamInfoFromJson(Map<String, dynamic> json) => ExamInfo(
      json['duration'] as int,
      json['code'] as String,
      json['enabled'] as bool,
      json['title'] as String,
      (json['questions'] as List<dynamic>).map((e) => e as String).toList(),
      json['date'] as int,
    );

Map<String, dynamic> _$ExamInfoToJson(ExamInfo instance) => <String, dynamic>{
      'duration': instance.duration,
      'code': instance.code,
      'enabled': instance.enabled,
      'title': instance.title,
      'questions': instance.questions,
      'date': instance.date,
    };
