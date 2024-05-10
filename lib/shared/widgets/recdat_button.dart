import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RecdatButton(
      {super.key, this.text = "button text", required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: RecdatStyles.buttonHeight,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: RecdatStyles.primaryButtonColor,
              shadowColor: RecdatStyles.shadowButtonColor,
              elevation: RecdatStyles.shadowElevation,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(RecdatStyles.borderRadius))),
          child: Text(
            text,
            style: const TextStyle(
                color: RecdatStyles.defaultColor,
                fontSize: RecdatStyles.buttonFontSize),
          ),
        ));
  }
}
