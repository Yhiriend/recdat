import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatNavbar extends StatelessWidget {
  final void Function(int) onTabChanged;

  const RecdatNavbar({Key? key, required this.onTabChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RecdatStyles.blueDarkColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
        child: GNav(
          backgroundColor: RecdatStyles.blueDarkColor,
          color: RecdatStyles.defaultTextColor,
          activeColor: RecdatStyles.defaultTextColor,
          tabBackgroundColor: RecdatStyles.defaultBackTextColor,
          gap: 5,
          padding: const EdgeInsets.all(12.0),
          onTabChange: (index) {
            onTabChanged(
                index); // Llama al callback cuando se cambia de pestaña
          },
          tabs: const [
            GButton(
              icon: Icons.qr_code,
              text: 'Qrcode',
            ),
            GButton(
              icon: Icons.insert_chart_outlined_outlined,
              text: 'Stadistic',
            ),
            GButton(
              icon: Icons.notifications,
              text: 'Notifications',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            )
          ],
        ),
      ),
    );
  }
}
