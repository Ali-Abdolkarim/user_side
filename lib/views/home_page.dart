import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:user_side/models/exam_info.dart';
import 'package:user_side/views/exam_page.dart';
import 'package:user_side/views/widgets/buttons.dart';
import 'package:user_side/views/widgets/c_texts.dart';
import 'package:user_side/views/widgets/constants.dart';
import 'package:user_side/views/widgets/fields.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  GetStorage storage = GetStorage();

  void enterExam() async {
    setState(() {
      _loading = true;
    });

    var currentExamResponse = await db
        .collection(Texts.EXAMS)
        .where(Texts.CODEE, isEqualTo: _codeController.text.trim())
        .where(Texts.ENABLED, isEqualTo: true)
        .get();

    if (currentExamResponse.docs.isEmpty) {
      Get.defaultDialog(
          radius: 6,
          cancel: SimpleButton(
            'Cancel',
            action: () => Get.back(),
            height: 35,
            borderRadius: 6,
          ),
          content: const CText('Wrong Code'));
      setState(() {
        _loading = false;
      });
    } else {
      ExamInfo exam = ExamInfo.fromJson(currentExamResponse.docs[0].data());

      if (DateTime.now().millisecondsSinceEpoch < exam.date) {
        Get.defaultDialog(
            radius: 6,
            cancel: SimpleButton(
              'Cancel',
              action: () => Get.back(),
              height: 35,
              borderRadius: 6,
            ),
            content: const CText('Test hasn\'t started'));
        setState(() {
          _loading = false;
        });
        return;
      }
      DateTime timeAndDuration = DateTime.fromMillisecondsSinceEpoch(
          exam.date + exam.duration * 60 * 1000);
      if (DateTime.now().isAfter(timeAndDuration)) {
        Get.defaultDialog(
            radius: 6,
            cancel: SimpleButton(
              'Cancel',
              action: () => Get.back(),
              height: 35,
              borderRadius: 6,
            ),
            content: const CText('Test has finished'));
        setState(() {
          _loading = false;
        });
        return;
      }
      var username = await storage.read(Texts.USERNAME);
      //------------------------------------------>uncomment later below
      var examTakenResponse = await db
          .collection(Texts.EXAMS_TAKEN)
          .where(Texts.USERNAME, isEqualTo: username)
          .where(Texts.EXAM_ID, isEqualTo: currentExamResponse.docs[0].id)
          .get();
      if (examTakenResponse.docs.isNotEmpty &&
          examTakenResponse.docs[0].data()[Texts.SUBMITTED] != null &&
          examTakenResponse.docs[0].data()[Texts.SUBMITTED]) {
        Get.defaultDialog(
            radius: 6,
            cancel: SimpleButton(
              'Cancel',
              action: () => Get.back(),
              height: 35,
              borderRadius: 6,
            ),
            content: const CText(
                'You have participated in that test before and submitted your answer.'));
        setState(() {
          _loading = false;
        });
        return;
      }
      Get.defaultDialog(
          radius: 6,
          confirm: SimpleButton(
            'Start',
            action: () async {
              if (examTakenResponse.docs.isNotEmpty) {
                Get.back();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExamPage(
                      accentColor: const Color.fromARGB(255, 213, 44, 35),
                      subject: exam.title,
                      examId: currentExamResponse.docs[0].id,
                      examTakenId: examTakenResponse.docs[0].id),
                ));
              } else {
                var temp = {
                  Texts.EXAM_ID: currentExamResponse.docs[0].id,
                  Texts.USERNAME: username,
                  Texts.TITLE: exam.title,
                  Texts.RESULT: 0,
                };
                var examTakenResponse =
                    await db.collection(Texts.EXAMS_TAKEN).add(temp);
                Get.back();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExamPage(
                      accentColor: const Color.fromARGB(255, 213, 44, 35),
                      subject: exam.title,
                      examId: currentExamResponse.docs[0].id,
                      examTakenId: examTakenResponse.id),
                ));
              }
            },
            height: 35,
            borderRadius: 6,
          ),
          cancel: SimpleButton(
            'Cancel',
            action: () => Get.back(),
            height: 35,
            borderRadius: 6,
          ),
          content: const CText('You are about to start the exam'));
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20, 20, 20, 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const CText('Logout'),
                            Container(
                                margin: const EdgeInsetsDirectional.fromSTEB(
                                    20, 0, 0, 0),
                                child: const Icon(Icons.logout)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/input.png',
                            height: size.height * .35,
                          ),
                          Container(
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                8, 50, 8, 16),
                            child: const CText('Enter Test Code'),
                          ),
                          Container(
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                8, 0, 8, 8),
                            child: Form(
                              key: _formKey,
                              child:
                                  SimpleFormInput(controller: _codeController),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                8, 8, 8, 0),
                            child: SimpleButton(
                              'Enter',
                              action: enterExam,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
