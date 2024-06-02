import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatButtonAsync extends StatefulWidget {
  final String text;
  final String color;
  final Future<void> Function() onPressed;

  const RecdatButtonAsync({
    Key? key,
    this.text = "button text",
    required this.onPressed,
    this.color = "primary",
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
        style: _buildButtonType(widget.color),
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
                style: _buildTextStyle(widget.color),
              ),
      ),
    );
  }

  TextStyle _buildTextStyle(String type) {
    Color textColor;
    FontWeight fontWeight;

    switch (type) {
      case "warning":
        textColor = RecdatStyles.warningColor;
        fontWeight = FontWeight.bold;
        break;
      case "success":
        textColor = RecdatStyles.activePill;
        fontWeight = FontWeight.bold;
        break;
      case "primary":
        textColor = RecdatStyles.whiteColor;
        fontWeight = FontWeight.normal;
        break;
      default:
        textColor = RecdatStyles.defaultTextColor;
        fontWeight = FontWeight.normal;
        break;
    }

    return TextStyle(
      color: textColor,
      fontSize: RecdatStyles.buttonFontSize,
      fontWeight: fontWeight,
    );
  }

  ButtonStyle _buildButtonType(String type) {
    if (type == "warning") {
      return ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Fondo transparente
        shadowColor: Colors.transparent, // Sin sombra
        elevation: 0, // Sin elevación
        side: BorderSide(
          color: RecdatStyles.warningColor, // Color del borde
          width: 2, // Ancho del borde
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RecdatStyles.borderRadius),
        ),
      );
    } else if (type == "success") {
      return ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Fondo transparente
        shadowColor: Colors.transparent, // Sin sombra
        elevation: 0, // Sin elevación
        side: BorderSide(
          color: RecdatStyles.activePill, // Color del borde
          width: 2, // Ancho del borde
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RecdatStyles.borderRadius),
        ),
      );
    } else {
      return ElevatedButton.styleFrom(
        backgroundColor:
            RecdatStyles.primaryButtonColor, // Fondo de color para otros tipos
        shadowColor: RecdatStyles.shadowButtonColor,
        elevation: RecdatStyles.shadowElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RecdatStyles.borderRadius),
        ),
      );
    }
  }
}
