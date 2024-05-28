import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatMultiselectController {
  final List<String> _selectedOptions = [];

  List<String> get selectedOptions => _selectedOptions;

  bool isSelected(String option) {
    return _selectedOptions.contains(option);
  }

  void selectOption(String option) {
    if (!_selectedOptions.contains(option)) {
      _selectedOptions.add(option);
    }
  }

  void deselectOption(String option) {
    _selectedOptions.remove(option);
  }
}

class Entry {
  final String title;
  final List<Entry> children;
  final IconData? icon;
  final bool isCourse;

  Entry(this.title,
      [this.children = const <Entry>[], this.icon, this.isCourse = false]);
}

class RecdatMultiselect extends StatelessWidget {
  final List<Entry> data;
  final RecdatMultiselectController controller;
  final Color? color;

  const RecdatMultiselect({
    Key? key,
    required this.data,
    required this.controller,
    this.color = RecdatStyles.blueDarkColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RecdatStyles.borderRadius),
              color: color == RecdatStyles.textFieldLight
                  ? RecdatStyles.textFieldColorGray
                  : RecdatStyles.textFieldColorBlue,
            ),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return EntryItem(
                  entry: data[index],
                  isSelected: controller.isSelected(data[index].title),
                  onSelected: (selected) {
                    if (selected == true) {
                      controller.selectOption(data[index].title);
                    } else {
                      controller.deselectOption(data[index].title);
                    }
                  },
                );
              },
              shrinkWrap: true,
            ),
          ),
        );
      },
    );
  }
}

class EntryItem extends StatelessWidget {
  final Entry entry;
  final bool isSelected;
  final ValueChanged<bool?> onSelected;

  const EntryItem({
    Key? key,
    required this.entry,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return entry.isCourse
        ? ListTile(
            title: Row(
              children: [
                if (entry.icon != null)
                  Icon(
                    entry.icon,
                    color: RecdatStyles.defaultColor,
                  ),
                Text(entry.title),
                Spacer(),
                Checkbox(
                  value: isSelected,
                  onChanged: onSelected,
                ),
              ],
            ),
          )
        : ExpansionTile(
            key: PageStorageKey<Entry>(entry),
            title: Row(
              children: [
                if (entry.icon != null)
                  Icon(
                    entry.icon,
                    color: RecdatStyles.defaultColor,
                  ),
                Text(entry.title),
              ],
            ),
            children: entry.children
                .map((subEntry) => EntryItem(
                      entry: subEntry,
                      isSelected: isSelected,
                      onSelected: onSelected,
                    ))
                .toList(),
          );
  }
}
