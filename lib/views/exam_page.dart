import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_side/models/exam_info.dart';
import 'package:user_side/models/exam_question.dart';
import 'package:user_side/views/widgets/buttons.dart';
import 'package:user_side/views/widgets/c_texts.dart';
import 'package:user_side/views/widgets/constants.dart';
import 'package:user_side/views/widgets/question.dart';

class ExamPage extends StatefulWidget {
  final Color accentColor;
  final String subject;
  final String? examTakenId;

  final String examId;

  const ExamPage({
    Key? key,
    required this.accentColor,
    required this.subject,
    required this.examId,
    this.examTakenId,
  }) : super(key: key);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  var isAnswer = false;
  var _timeRemaining = 20;
  late Timer timer;
  var questionsAnswered = 0;
  var correctAnswers = 0;
  var wrongAnswers = 0;
  var answers = {};
  var _loading = true;
  List<ExamQuestion> questions = [];
  bool isRecording = false;
  // late int _selectedLangId;
  // late TextDirection direction;

  late ExamInfo _examInfo;
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    questions = [];

    setState(() {
      _loading = true;
    });
    QuerySnapshot? answersSnapshot;
    db
        .collection(Texts.EXAMS)
        .doc(widget.examId)
        .snapshots()
        .listen((event) async {
      if (event.data() != null) {
        _examInfo = ExamInfo.fromJson(event.data()!);
        QuerySnapshot questionsResponse = await db
            .collection(Texts.QUESTIONS)
            .where(Texts.EXAM_ID, isEqualTo: widget.examId)
            .get();

        questions.clear();
        for (var element in questionsResponse.docs) {
          questions.add(
              ExamQuestion.fromJson((element.data()!) as Map<String, dynamic>));

          answersSnapshot = await db
              .collection(Texts.ANSWERS)
              .where(Texts.QUESTION_ID, isEqualTo: element.id)
              .get();

          questions[questions.length - 1].answerItemModel =
              AnswerItemModel.fromJson(
                  (answersSnapshot!.docs[0].data() as Map<String, dynamic>?)!);
          questions[questions.length - 1].selectedAnswers = [];
          for (var i = 0;
              i <
                  questions[questions.length - 1]
                      .answerItemModel!
                      .answers
                      .length;
              i++) {
            questions[questions.length - 1].selectedAnswers!.add(false);
          }
        }

        if (questions.isNotEmpty) {
          // answers = List.generate(questions.length, (_) => null);
          _timeRemaining = ((_examInfo.date +
                      _examInfo.duration * 60 * 1000 -
                      DateTime.now().millisecondsSinceEpoch) /
                  1000)
              .floor();
          // log(_timeRemaining.toString());
          // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          //   if (mounted) {
          //     setState(() {
          //       _timeRemaining--;
          //     });
          //   }
          //   if (_timeRemaining == 0) {
          //     calculateResult(context);
          //     timer.cancel();
          //   }
          // });
        }
        if (mounted) {
          setState(() {});
        }
      }
    });

    setState(() {
      _loading = false;
    });
  }

  //changed this one -------------------------------------------------------->
  void updateAnswer(int? index, String? answer) {
    if (index != null) {
      answers[index] = answer;
      setState(() {});
    }
  }

  void showBackDialog() {
    Get.defaultDialog(
      title: 'Do you really want to exit the Exam?',
      titleStyle: const TextStyle(fontSize: 16),
      radius: 6,
      content: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
        child: Column(
          children: [
            SimpleButton(
              'Exit',
              action: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
              child: SimpleButton(
                'Cancel',
                action: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: isRecording
          ? const Center()
          : Scaffold(
              // appBar: AppBar(
              //   iconTheme: const IconThemeData(color: Colors.white),
              //   elevation: 0,
              //   title: const CustomText(
              //     text: 'تاقیکردنەوە',
              //     color: Colors.white,
              //     fontSize: 19,
              //   ),
              //   backgroundColor: widget.accentColor,
              //   shape: const RoundedRectangleBorder(
              //     borderRadius: BorderRadius.vertical(
              //       bottom: Radius.circular(10),
              //     ),
              //   ),
              // ),
              body: _loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              34, 28, 8, 8),
                          child: BackButton(
                            onPressed: () {
                              questions.isEmpty
                                  ? Navigator.pop(context)
                                  : showBackDialog();
                            },
                          ),
                        ),
                        questions.isEmpty
                            ? const Center(
                                child: CText(
                                  'هیچ پرسیارێک بەردەست نیە.',
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  margin: const EdgeInsetsDirectional.fromSTEB(
                                      34, 8, 34, 0),
                                  child: Column(
                                    children: [
                                      // isAnswer
                                      //     ? QuizInfoCard(
                                      //         accentColor: widget.accentColor,
                                      //         icon: 'history',
                                      //         againText: 'دووبارەکردنەوە',
                                      //         timeRemaining: _timeRemaining,
                                      //         questionsAnswered: questions
                                      //             .where((element) => element
                                      //                 .selectedAnswers!
                                      //                 .contains(true))
                                      //             .length,
                                      //         title: ' :ئەنجامی تاقیکردنەوە',
                                      //         items: [
                                      //           QuizInfoItem(
                                      //             'وەڵامی ڕاست  :',
                                      //             '    $correctAnswers',
                                      //             showLine: false,
                                      //           ),
                                      //           QuizInfoItem(
                                      //             'وەڵامی هەڵە   :',
                                      //             '    $wrongAnswers',
                                      //             showLine: false,
                                      //           ),
                                      //         ],
                                      //         totalQuestions: questions.length)
                                      //     :
                                      QuizInfoCard(
                                        accentColor: widget.accentColor,
                                        icon: 'clock',
                                        timeFinished: () =>
                                            calculateResult(context),
                                        questionsAnswered: questions
                                            .where((element) => element
                                                .selectedAnswers!
                                                .contains(true))
                                            .length,
                                        totalQuestions: questions.length,
                                        timeRemaining: _timeRemaining,
                                        initialTime: _examInfo.duration,
                                        items: [
                                          // QuizInfoItem(
                                          //     'ئاستێک', widget.level),
                                          // QuizInfoItem(
                                          //     'یەکە', widget.section),
                                          QuizInfoItem('بابەت', widget.subject),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(0, 4, 0, 0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ...questions
                                                    .map(
                                                      (e) => QuestionCard(
                                                        question: e,
                                                        accentColor:
                                                            widget.accentColor,
                                                        showAnswer: isAnswer,

                                                        // textDirection:
                                                        //     direction,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                0, 10, 0, 0),
                                                        updateAnswerAction:
                                                            (index) {
                                                          // updateAnswer(p0, p1);

                                                          e.selectedAnswers![
                                                                  index!] =
                                                              !e.selectedAnswers![
                                                                  index];
                                                          setState(() {});
                                                          updateQuestionsInServer();
                                                        },
                                                        questionIndex: questions
                                                            .indexOf(e),
                                                        resultAction: () {
                                                          if (e.correctAnswer !=
                                                                  null ||
                                                              e.correctAnswer !=
                                                                      null &&
                                                                  (e.correctAnswer!
                                                                      .isNotEmpty)) {
                                                            // Get.defaultDialog(
                                                            //   content: CText(
                                                            //     align: TextAlign
                                                            //         .start,
                                                            //     e.result ?? '',
                                                            //     sizee: 14,
                                                            //   ),
                                                            // items: [
                                                            // e.questionType ==
                                                            //         0
                                                            // ?
                                                            // CText(
                                                            //   align:
                                                            //       TextAlign
                                                            //           .start,
                                                            //   e.result ??
                                                            //       '',
                                                            //   sizee: 14,
                                                            // ),
                                                            // : Html(
                                                            //     data: e.result ??
                                                            //         '',
                                                            //   )
                                                            // ],
                                                            // );
                                                          }
                                                        },
                                                      ),
                                                    )
                                                    .toList(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SimpleButton(
                                        isAnswer
                                            ? 'دووبارەکردنەوە'
                                            : 'تەواوکردن',
                                        action: () {
                                          if (isAnswer) {
                                            Navigator.of(context).pop();
                                            return;
                                          }
                                          calculateResult(context);
                                        },
                                        backgroundColor: widget.accentColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
            ),
    );
  }

  void updateQuestionsInServer() {
    var temp = [];
    for (var element in questions) {
      temp.add(element.toJson());
    }
    db
        .collection(Texts.EXAMS_TAKEN)
        .doc(widget.examTakenId)
        .update({Texts.QUESTIONS: temp});
  }

  void calculateResult(BuildContext context) {
    var questionAllCorrectFlag = true;

    for (var element in questions) {
      correctAnswers = 0;
      wrongAnswers = 0;
      questionAllCorrectFlag = true;
      for (var i = 0; i < element.correctAnswer!.length; i++) {
        if (element.correctAnswer![i] != element.selectedAnswers![i]) {
          questionAllCorrectFlag = false;
          wrongAnswers++;
        } else {
          correctAnswers++;
        }
      }
      if (questionAllCorrectFlag) {
        correctAnswers += int.parse(element.extraPoint ?? '0');
      }
    }

    db
        .collection(Texts.EXAMS_TAKEN)
        .doc(widget.examTakenId)
        .update({Texts.SUBMITTED: true, Texts.RESULT: correctAnswers});

    // for (var item in answers.values) {
    //   if (item == null) {
    //     continue;
    //   }
    //   if (item == 'true') {
    //     correctAnswers++;
    //   } else {
    //     wrongAnswers++;
    //   }
    // }
    setState(() {
      isAnswer = !isAnswer;
    });
    var result = answers.values.where((element) => element == true).length /
        answers.length;
    Get.defaultDialog(
      content: Column(
        children: [
          // CText(
          //   'ئەنجامەکەت: ' +
          //       '${(result * 100).toInt()}'
          //           '/100',
          //   color: widget.accentColor,
          //   sizee: 14,
          //   padding: const EdgeInsetsDirectional.only(),
          // ),
          // if (result < 70)
          //   CustomText(
          //     text:'',
          //         // 'ببورە ناتوانیت بچیتە وانەی دواتر چوونکە نمرەکەت کەمترە لە  70/100.',
          //     color: widget.accentColor,
          //     fontSize: 14,
          //     padding: const EdgeInsetsDirectional.only(),
          //   ),
          // if (result < 70)
          CText(
            result > 0.9
                ? 'نایاب'
                : result > 0.8
                    ? 'زۆر باشە'
                    : result > 0.7
                        ? 'باشە'
                        : result > 0.6
                            ? 'ناوەند'
                            : result > 0.5
                                ? 'پەسەند'
                                : 'لاواز',
            color: Colors.grey,
            sizee: 14,
            padding: const EdgeInsetsDirectional.only(top: 12),
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(top: 12),
            child: SimpleButton(
              result < 70 ? 'دووبارەکردنەوە' : 'دەرچوون',
              action: () {
                Navigator.of(context).pop();
              },
              backgroundColor: widget.accentColor,
            ),
          )
        ],
      ),
    );
  }
}
