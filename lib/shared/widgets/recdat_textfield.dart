import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatTextfield extends StatefulWidget {
  final String placeholder;
  final IconData? icon;
  final String? Function(String?)? validator;

  const RecdatTextfield({
    Key? key,
    required this.placeholder,
    this.icon,
    this.validator,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecdatTextfieldState createState() => _RecdatTextfieldState();
}

class _RecdatTextfieldState extends State<RecdatTextfield> {
  bool _hasError =
      false; // Estado local para indicar si hay un error en el campo

  @override
  Widget build(BuildContext context) {
    final double height = _hasError
        ? RecdatStyles.textFieldHeight + 25
        : RecdatStyles.textFieldHeight;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          TextFormField(
            cursorColor: RecdatStyles.cursorColor,
            style: const TextStyle(
              color: RecdatStyles.defaultTextColor,
              fontSize: RecdatStyles.textFieldFontSize,
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: const TextStyle(color: RecdatStyles.hintTextColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(RecdatStyles.borderRadius),
                borderSide: BorderSide.none,
              ),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.2),
              filled: true,
              prefixIcon: widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: RecdatStyles.defaultColor,
                    )
                  : null,
            ),
            validator: (value) {
              setState(() {
                _hasError = widget.validator != null &&
                    widget.validator!(value) != null;
              });
              return widget.validator != null ? widget.validator!(value) : null;
            },
          ),
        ],
      ),
    );
  }
}
