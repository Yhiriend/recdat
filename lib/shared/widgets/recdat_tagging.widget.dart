import 'package:flutter/material.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class TaggingWidget extends StatefulWidget {
  final String color;
  final IconData? icon;
  final List<CourseModel> initialTags;
  final List<CourseModel> suggestions;
  final Function(List<CourseModel>) onChange;

  TaggingWidget({
    Key? key,
    this.color = RecdatStyles.textFieldDark,
    this.icon,
    required this.initialTags,
    required this.suggestions,
    required this.onChange,
  }) : super(key: key);

  @override
  _TaggingWidgetState createState() => _TaggingWidgetState();
}

class _TaggingWidgetState extends State<TaggingWidget> {
  late List<CourseModel> _tags;
  late List<CourseModel> _availableSuggestions;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tags = widget.initialTags;
    _availableSuggestions = List.from(widget.suggestions);
  }

  void _addTag(CourseModel tag) {
    setState(() {
      if (_availableSuggestions.contains(tag)) {
        _tags.add(tag);
        _availableSuggestions.remove(tag);
        _textController.clear();
        widget.onChange(_tags);
      }
    });
  }

  void _removeTag(CourseModel tag) {
    setState(() {
      _tags.remove(tag);
      _availableSuggestions.add(tag);
      widget.onChange(_tags);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          children: _tags.map((tag) {
            return Chip(
              label: Text(tag.name ?? ''),
              onDeleted: () => _removeTag(tag),
            );
          }).toList(),
        ),
        Autocomplete<CourseModel>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<CourseModel>.empty();
            }
            return _availableSuggestions.where((CourseModel option) {
              return option.name!
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          displayStringForOption: (CourseModel option) => option.name ?? '',
          onSelected: (CourseModel selection) {
            _addTag(selection);
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            _textController.text = textEditingController.text;
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Asigna cursos",
                hintStyle:
                    const TextStyle(color: RecdatStyles.hintTextColorDark),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(RecdatStyles.borderRadius),
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
              style: TextStyle(
                color: widget.color == RecdatStyles.textFieldLight
                    ? RecdatStyles.blueDarkColor
                    : RecdatStyles.defaultTextColor,
                fontSize: RecdatStyles.textFieldFontSize,
              ),
            );
          },
        ),
      ],
    );
  }
}
