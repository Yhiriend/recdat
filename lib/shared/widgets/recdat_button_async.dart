import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatButtonAsync extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;

  const RecdatButtonAsync({
    Key? key,
    this.text = "button text",
    required this.onPressed,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecdatButtonAsyncState createState() => _RecdatButtonAsyncState();
}

class _RecdatButtonAsyncState extends State<RecdatButtonAsync> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: RecdatStyles.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await widget.onPressed();
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: RecdatStyles.primaryButtonColor,
          shadowColor: RecdatStyles.shadowButtonColor,
          elevation: RecdatStyles.shadowElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RecdatStyles.borderRadius),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    RecdatStyles.whiteColor,
                  ),
                ),
              )
            : Text(
                widget.text,
                style: const TextStyle(
                  color: RecdatStyles.whiteColor,
                  fontSize: RecdatStyles.buttonFontSize,
                ),
              ),
      ),
    );
  }
}
