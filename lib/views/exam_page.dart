import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_side/models/exam_question.dart';
import 'package:user_side/models/exam_request.dart';
import 'package:user_side/views/widgets/buttons.dart';
import 'package:user_side/views/widgets/c_texts.dart';
import 'package:user_side/views/widgets/question.dart';

class ExamPage extends StatefulWidget {
  final Color accentColor;
  final List<ExamRequest> examRequests;
  final String level;
  final String subject;
  final String section;
  final int quantity;

  const ExamPage({
    Key? key,
    required this.examRequests,
    required this.accentColor,
    required this.level,
    required this.section,
    required this.subject,
    required this.quantity,
  }) : super(key: key);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  var isAnswer = false;
  var _timeRemaining = 3600;
  late Timer timer;
  var questionsAnswered = 0;
  var correctAnswers = 0;
  var wrongAnswers = 0;
  var answers = [];
  var _loading = true;
  List<ExamQuestion>? questions = [];
  bool isRecording = false;
  // late int _selectedLangId;
  late TextDirection direction;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  void _loadData() async {
    questions = [];

    // await Provider.of<SchoolProvider>(context, listen: false).loadQuestions(
    //     context: context,
    //     examRequests: widget.examRequests,
    //     quantity: widget.quantity);
    direction =
        // GenerallyNeeded.isRTL(questions![0].question!)
        //     ? TextDirection.rtl
        //     :
        TextDirection.ltr;
    // _selectedLangId = (await SharedPref.load(StorageKeys.selectedLanguage)) - 1;
    // log(_selectedLangId.toString());
    setState(() {
      _loading = false;
    });
    if (questions != null) {
      answers = List.generate(questions!.length, (_) => null);
      _timeRemaining = questions!.length * 120;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _timeRemaining--;
        });
        if (_timeRemaining == 0) {
          calculateResult(context);

          timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
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
      title: 'ئایا دڵنیایت لە کۆتایی هێنان بە تاقیکردنەوە؟',
      titleStyle: const TextStyle(fontSize: 16),
      content: Column(
        children: [
          SimpleButton(
            'دەرچوون',
            action: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          SimpleButton(
            'پاشگەزبوونەوە',
            action: () {
              Navigator.of(context).pop();
            },
          ),
        ],
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
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              Platform.isIOS ? 40 : 34, 28, 8, 8),
                          child: BackButton(
                            onPressed: () {
                              questions!.isEmpty
                                  ? Navigator.pop(context)
                                  : showBackDialog();
                            },
                          ),
                        ),
                        questions!.isEmpty
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
                                      isAnswer
                                          ? QuizInfoCard(
                                              accentColor: widget.accentColor,
                                              icon: 'history',
                                              againText: 'دووبارەکردنەوە',
                                              questionsAnswered: answers
                                                  .where((element) =>
                                                      element != null)
                                                  .length,
                                              title: ' :ئەنجامی تاقیکردنەوە',
                                              items: [
                                                QuizInfoItem(
                                                  'وەڵامی ڕاست  :',
                                                  '    $correctAnswers',
                                                  showLine: false,
                                                ),
                                                QuizInfoItem(
                                                  'وەڵامی هەڵە   :',
                                                  '    $wrongAnswers',
                                                  showLine: false,
                                                ),
                                              ],
                                              totalQuestions: questions!.length)
                                          : QuizInfoCard(
                                              accentColor: widget.accentColor,
                                              icon: 'clock',
                                              questionsAnswered: answers
                                                  .where((element) =>
                                                      element != null)
                                                  .length,
                                              totalQuestions: questions!.length,
                                              timeRemaining: _timeRemaining,
                                              items: [
                                                QuizInfoItem(
                                                    'ئاستێک', widget.level),
                                                QuizInfoItem(
                                                    'یەکە', widget.section),
                                                QuizInfoItem(
                                                    'بابەت', widget.subject),
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
                                                ...questions!
                                                    .map(
                                                      (e) => QuestionCard(
                                                        question: e,
                                                        accentColor:
                                                            widget.accentColor,
                                                        showAnswer: isAnswer,
                                                        textDirection:
                                                            direction,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                0, 10, 0, 0),
                                                        updateAnswerAction:
                                                            (p0, p1) {
                                                          updateAnswer(p0, p1);
                                                        },
                                                        questionIndex:
                                                            questions!
                                                                .indexOf(e),
                                                        resultAction: () {
                                                          if (e.result !=
                                                                  null ||
                                                              e.result !=
                                                                      null &&
                                                                  (e.result!
                                                                      .isNotEmpty)) {
                                                            Get.defaultDialog(
                                                              content: CText(
                                                                align: TextAlign
                                                                    .start,
                                                                e.result ?? '',
                                                                sizee: 14,
                                                              ),
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
                                                            );
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

  void calculateResult(BuildContext context) {
    correctAnswers = 0;
    wrongAnswers = 0;
    for (var item in answers) {
      if (item == null) {
        continue;
      }
      if (item) {
        correctAnswers++;
      } else {
        wrongAnswers++;
      }
    }
    setState(() {
      isAnswer = !isAnswer;
    });
    var result =
        answers.where((element) => element == true).length / answers.length;
    Get.defaultDialog(
      content: Column(
        children: [
          CText(
            'ئەنجامەکەت: ' +
                '${(result * 100).toInt()}'
                    '/100',
            color: widget.accentColor,
            sizee: 14,
            padding: const EdgeInsetsDirectional.only(),
          ),
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
