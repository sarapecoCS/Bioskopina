import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/gradient_button.dart';

Future<void> showConfirmationDialog(
    BuildContext context,
    Widget? dialogTitle,
    Widget? content,
    VoidCallback onPressedYes) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Cannot dismiss by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent, // Make Dialog itself transparent
        child: Container(
          decoration: BoxDecoration(
            color: Palette.darkPurple, // Your dark background
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5), // Gray border with opacity
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AlertDialog(
              backgroundColor: Colors.transparent, // Transparent to show Container color
              elevation: 0,
              title: dialogTitle,
              content: content,
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 10, top: 10),
                  child: GradientButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    width: 85,
                    height: 28,
                    borderRadius: 15,
                    gradient: Palette.buttonGradient2,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Palette.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 10, top: 10),
                  child: GradientButton(
                    onPressed: () {
                      onPressedYes();
                      Navigator.of(context).pop();
                    },
                    width: 85,
                    height: 28,
                    borderRadius: 15,
                    gradient: Palette.buttonGradient,
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Palette.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showCustomConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onYes,
  required VoidCallback onNo,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help, color: Colors.yellow, size: 60),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // YES button with gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple], // Or your colors
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: onYes,
                      child: const Text("Yes"),
                    ),
                  ),
                  // NO button in green
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: onNo,
                    child: const Text("No"),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
