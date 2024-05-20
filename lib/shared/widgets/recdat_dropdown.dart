import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatDropdown extends StatefulWidget {
  final String placeholder;
  final List<String> options;
  final TextEditingController controller;
  final IconData? icon;
  final String? color;
  final String? Function(String?)? validator;

  const RecdatDropdown({
    Key? key,
    required this.placeholder,
    required this.controller,
    required this.options,
    this.icon,
    this.validator,
    this.color = RecdatStyles.textFieldDark,
  }) : super(key: key);

  @override
  _RecdatDropdownState createState() => _RecdatDropdownState();
}

class _RecdatDropdownState extends State<RecdatDropdown> {
  String? _selectedOption;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.options.contains(widget.controller.text)
        ? widget.controller.text
        : null;
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
          DropdownButtonFormField<String>(
            value: _selectedOption,
            items: widget.options
                .map((option) => DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedOption = newValue;
                widget.controller.text = newValue!;
              });
            },
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: const TextStyle(
                  color: RecdatStyles.hintTextColorDark, fontSize: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(RecdatStyles.borderRadius),
                borderSide: BorderSide.none,
              ),
              fillColor: widget.color == RecdatStyles.textFieldLight
                  ? RecdatStyles.textFieldColorGray
                  : RecdatStyles.textFieldColorBlue,
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
