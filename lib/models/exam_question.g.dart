// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamQuestion _$ExamQuestionFromJson(Map<String, dynamic> json) => ExamQuestion(
      question: json['question'] as String?,
      answerItemModel: json['answerItemModel'] == null
          ? null
          : AnswerItemModel.fromJson(
              json['answerItemModel'] as Map<String, dynamic>),
      correctAnswer: (json['correct_answer'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      examId: json['exam_id'] as String?,
      extraPoint: json['extra_point'] as String?,
      answersLink: json['answers_link'] as String?,
    );

Map<String, dynamic> _$ExamQuestionToJson(ExamQuestion instance) =>
    <String, dynamic>{
      'correct_answer': instance.correctAnswer,
      'answers_link': instance.answersLink,
      'extra_point': instance.extraPoint,
      'exam_id': instance.examId,
      'question': instance.question,
      'answerItemModel': instance.answerItemModel,
    };

AnswerItemModel _$AnswerItemModelFromJson(Map<String, dynamic> json) =>
    AnswerItemModel(
      json['question_id'] as String,
      (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AnswerItemModelToJson(AnswerItemModel instance) =>
    <String, dynamic>{
      'answers': instance.answers,
      'question_id': instance.questionId,
    };
