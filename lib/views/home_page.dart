import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_side/views/widgets/buttons.dart';
import 'package:user_side/views/widgets/c_texts.dart';
import 'package:user_side/views/widgets/fields.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _codeController = TextEditingController();

  void enterExam() {
    Get.defaultDialog(
        radius: 6,
        confirm: SimpleButton(
          'Start',
          action: () => print('start'),
          height: 35,
          borderRadius: 6,
        ),
        cancel: SimpleButton(
          'Cancel',
          action: () => Get.back(),
          height: 35,
          borderRadius: 6,
        ),
        content: CText('You are about to start the exam'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
              child: CText('Enter Test Code'),
            ),
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
              child: SimpleFormInput(controller: _codeController),
            ),
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
              child: SimpleButton(
                'Enter',
                action: enterExam,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
