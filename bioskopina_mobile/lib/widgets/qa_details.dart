import 'package:flutter/material.dart';

import '../widgets/gradient_button.dart';
import '../models/qa.dart';
import '../utils/colors.dart';

class QADetails extends StatefulWidget {
  final QA qa;
  const QADetails({super.key, required this.qa});

  @override
  State<QADetails> createState() => _QADetailsState();
}

class _QADetailsState extends State<QADetails> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Dialog(
        insetPadding: const EdgeInsets.all(17),
        alignment: Alignment.center,
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Palette.darkPurple,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Palette.lightPurple.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.qa.question!,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              (widget.qa.answer != "")
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        constraints:
                            BoxConstraints(maxHeight: screenSize.height * 0.2),
                        width: screenSize.width,
                        child: SingleChildScrollView(
                            child: Text(widget.qa.answer!)),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        "Answer coming soon...",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Palette.lightPurple.withOpacity(0.7)),
                      ),
                    ),
              GradientButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    FocusScope.of(context).unfocus();
                  },
                  width: 55,
                  height: 25,
                  borderRadius: 50,
                  gradient: Palette.buttonGradient,
                  child: const Text("OK",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Palette.white))),
            ],
          ),
        ));
  }
}
