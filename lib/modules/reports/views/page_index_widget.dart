import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class PageIndexWidget extends StatelessWidget {
  final void Function(int) onPageSelected;

  const PageIndexWidget({
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: RecdatStyles.blueDarkColor,
      foregroundColor: RecdatStyles.defaultTextColor,
      overlayColor: RecdatStyles.blueDarkColor,
      overlayOpacity: 0.4,
      spacing: 8,
      children: [
        SpeedDialChild(
          foregroundColor: RecdatStyles.blueDarkColor,
          child: const Icon(Icons.school),
          label: "General",
          onTap: () => onPageSelected(0),
        ),
        SpeedDialChild(
          foregroundColor: RecdatStyles.blueDarkColor,
          child: const Icon(Icons.school),
          label: "Puntualidad",
          onTap: () => onPageSelected(1),
        ),
        SpeedDialChild(
          foregroundColor: RecdatStyles.blueDarkColor,
          child: const Icon(Icons.groups_rounded),
          label: "Histórico asis. individual",
          onTap: () => onPageSelected(2),
        ),
        SpeedDialChild(
          foregroundColor: RecdatStyles.blueDarkColor,
          child: const Icon(Icons.groups_rounded),
          label: "Asis. justificadas vs No-justificadas",
          onTap: () => onPageSelected(3),
        ),
      ],
    );
  }
}
