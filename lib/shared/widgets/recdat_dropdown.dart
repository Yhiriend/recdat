import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/utils/iterable_extension.dart';

class DropdownOption {
  final String value;
  final String label;

  DropdownOption({required this.value, required this.label});
}

class RecdatDropdown extends StatefulWidget {
  final String placeholder;
  final List<DropdownOption> options;
  final TextEditingController controller;
  final IconData? icon;
  final String? color;
  final void Function(DropdownOption)? onChange;

  const RecdatDropdown({
    Key? key,
    required this.placeholder,
    required this.controller,
    required this.options,
    this.icon,
    this.onChange,
    this.color = RecdatStyles.textFieldDark,
  }) : super(key: key);

  @override
  _RecdatDropdownState createState() => _RecdatDropdownState();
}

class _RecdatDropdownState extends State<RecdatDropdown> {
  DropdownOption? _selectedOption;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.options.firstWhereOrNull(
      (option) => option.value == widget.controller.text,
    );
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
          DropdownButtonFormField<DropdownOption>(
            value: _selectedOption,
            items: widget.options
                .map((option) => DropdownMenuItem<DropdownOption>(
                      value: option,
                      child: Text(option.label),
                    ))
                .toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedOption = newValue;
                widget.controller.text = newValue!.value;
                if (widget.onChange != null) {
                  widget.onChange!(newValue);
                }
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
          ),
        ],
      ),
    );
  }
}
