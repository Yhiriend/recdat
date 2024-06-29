import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatInputDate extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final IconData? icon;
  final String? color;
  final String? Function(String?)? validator;
  final bool enabled;
  final ValueChanged<DateTime?>? onChanged; // Nueva propiedad onChanged

  const RecdatInputDate({
    Key? key,
    this.enabled = true,
    required this.placeholder,
    required this.controller,
    this.icon,
    this.validator,
    this.color,
    this.onChanged, // Añadir onChanged al constructor
  }) : super(key: key);

  @override
  _RecdatInputDateState createState() => _RecdatInputDateState();
}

class _RecdatInputDateState extends State<RecdatInputDate> {
  bool _hasError = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _controller.text = "${pickedDate.toLocal()}".split(' ')[0];
      });

      // Llamar a onChanged con la fecha seleccionada
      if (widget.onChanged != null) {
        widget.onChanged!(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = _hasError ? 75 : 50;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                textAlign: TextAlign.start,
                textDirection: TextDirection.ltr,
                enabled: widget.enabled,
                controller: _controller,
                cursorColor: Colors.blue,
                style: widget.enabled
                    ? const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      )
                    : const TextStyle(color: Colors.grey, fontSize: 16),
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: RecdatStyles.textFieldColorGray,
                  filled: true,
                  prefixIcon: widget.icon != null
                      ? Icon(
                          widget.icon,
                          color: Colors.blue,
                        )
                      : null,
                ),
                validator: (value) {
                  setState(() {
                    _hasError = widget.validator != null &&
                        widget.validator!(value) != null;
                  });
                  return widget.validator != null
                      ? widget.validator!(value)
                      : null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
