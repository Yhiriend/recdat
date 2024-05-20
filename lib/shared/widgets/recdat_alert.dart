import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatAlert extends StatelessWidget {
  final String alertType;
  final String title;
  final String message;
  final String buttonText;
  final Function onSubmit;

  const RecdatAlert({
    Key? key,
    required this.alertType,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? buttonColor;
    Color? iconColor;

    switch (alertType) {
      case 'warning':
        backgroundColor = const Color(0xFFFFE5B4);
        buttonColor = const Color(0xFFFFE5B4);
        iconColor = const Color(0xFFFFA500);
        break;
      case 'error':
        backgroundColor = const Color(0xFFFFCCCC);
        buttonColor = const Color(0xFFFFCCCC);
        iconColor = const Color(0xFFFF0000);
        break;
      case 'info':
        backgroundColor = const Color(0xFFCCE5FF);
        buttonColor = const Color(0xFFCCE5FF);
        iconColor = const Color(0xFF1E90FF);
        break;
      case 'success':
        backgroundColor = const Color(0xFFD4EDDA);
        buttonColor = const Color(0xFFD4EDDA);
        iconColor = const Color(0xFF28A745);
        break;
      default:
        backgroundColor = Colors.transparent;
        buttonColor = Colors.transparent;
        iconColor = Colors.transparent;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          CardDialog(
            backgroundColor: backgroundColor,
            iconColor: iconColor,
            title: title,
            message: message,
            buttonText: buttonText,
            onSubmit: onSubmit,
          ),
          Positioned(
            height: 40,
            width: 40,
            top: 0,
            right: 0,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(8),
                shape: const CircleBorder(),
                backgroundColor: RecdatStyles.defaultColor,
              ),
              child: const Icon(
                Icons.close,
                color: RecdatStyles.whiteColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CardDialog extends StatelessWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final String title;
  final String message;
  final String buttonText;
  final Function onSubmit;

  const CardDialog({
    Key? key,
    this.backgroundColor,
    this.iconColor,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: iconColor,
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(height: 4),
          Text(message),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 28),
                  foregroundColor: RecdatStyles.darkTextColor,
                  side: const BorderSide(
                    color: RecdatStyles.darkTextColor,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                        child: CircularProgressIndicator(
                      color: RecdatStyles.whiteColor,
                    )),
                  );

                  onSubmit().then((_) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                },
                child: Text(buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  foregroundColor: const Color(0xff2a303e),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 28),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
