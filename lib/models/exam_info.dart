import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exam_info.g.dart';

@JsonSerializable()
class ExamInfo extends Equatable {
  int duration;
  String code;
  bool enabled;
  String title;
  List<String> questions;
  int date;

  ExamInfo(this.duration, this.code, this.enabled, this.title, this.questions,
      this.date);

  factory ExamInfo.fromJson(Map<String, dynamic> json) =>
      _$ExamInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ExamInfoToJson(this);

  @override
  List<Object?> get props => [
        duration,
        code,
        title,
        enabled,
        questions,
        date,
      ];
}

// @JsonSerializable()
// class Sections extends Equatable {
//   int? id;
//   @JsonKey(name: 'school_exam_id')
//   int? schoolExamId;
//   String? title;
//   List<Parts>? parts;

//   Sections({
//     this.id,
//     this.schoolExamId,
//     this.title,
//     this.parts,
//   });

//   factory Sections.fromJson(Map<String, dynamic> json) =>
//       _$SectionsFromJson(json);

//   Map<String, dynamic> toJson() => _$SectionsToJson(this);

//   @override
//   List<Object?> get props => [id, schoolExamId, title, parts];
// }

// @JsonSerializable()
// class Parts extends Equatable {
//   int? id;
//   @JsonKey(name: 'school_exam_section_id')
//   int? schoolExamSectionId;
//   String? title;

//   Parts({
//     this.id,
//     this.schoolExamSectionId,
//     this.title,
//   });

//   factory Parts.fromJson(Map<String, dynamic> json) => _$PartsFromJson(json);

//   Map<String, dynamic> toJson() => _$PartsToJson(this);

//   @override
//   // TODO: implement props
//   List<Object?> get props => [id, schoolExamSectionId, title];
// }
