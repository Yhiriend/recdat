import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:recdat/utils/utils.dart';

class RecdatMultiselectTextField extends StatefulWidget {
  final List<GeneralOptionsSelectWidget> options;
  final TextEditingController controller;
  final TextInputType type;
  final String placeholder;
  final int maxSelections;

  const RecdatMultiselectTextField({
    Key? key,
    required this.options,
    required this.controller,
    this.type = TextInputType.text,
    this.placeholder = 'Select',
    this.maxSelections = 1,
  }) : super(key: key);

  @override
  _RecdatMultiselectTextFieldState createState() =>
      _RecdatMultiselectTextFieldState();
}

class _RecdatMultiselectTextFieldState
    extends State<RecdatMultiselectTextField> {
  late final List<MultiSelectItem<GeneralOptionsSelectWidget>> _items;
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _items = widget.options
        .map((option) => MultiSelectItem<GeneralOptionsSelectWidget>(
              option,
              option.label,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectBottomSheetField<GeneralOptionsSelectWidget>(
        key: _multiSelectKey,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        title: const Text("Cursos"),
        buttonText: const Text("Favorite Animals"),
        items: _items,
        validator: (values) {
          if (values == null || values.isEmpty) {
            return "Required";
          }
          List<String> names = values.map((e) => e.label).toList();
          if (names.contains("Frog")) {
            return "Frogs are weird!";
          }
          return null;
        },
        onConfirm: (values) {
          setState(() {
            //_selectedOptions = values;
          });
        });
  }
}
