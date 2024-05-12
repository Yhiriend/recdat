import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatTextfield extends StatefulWidget {
  final String placeholder;
  final IconData? icon;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType type;

  const RecdatTextfield({
    Key? key,
    required this.placeholder,
    required this.controller,
    this.type = TextInputType.text,
    this.icon,
    this.validator,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecdatTextfieldState createState() => _RecdatTextfieldState();
}

class _RecdatTextfieldState extends State<RecdatTextfield> {
  bool _hasError = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

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
            controller: _controller,
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
            keyboardType: widget.type,
          ),
        ],
      ),
    );
  }
}
