import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class RecdatNavbar extends StatefulWidget {
  final void Function(int) onTabChanged;

  const RecdatNavbar({Key? key, required this.onTabChanged}) : super(key: key);

  @override
  State<RecdatNavbar> createState() => _RecdatNavbarState();
}

class _RecdatNavbarState extends State<RecdatNavbar> {
  int badge = 3;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userRol = authProvider.user?.rol;
    final isAdmin = userRol == UserRole.admin.value;
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
            widget.onTabChanged(index);
          },
          tabs: isAdmin
              ? [
                  const GButton(
                    icon: Icons.qr_code,
                    text: 'Qrcode',
                  ),
                  const GButton(
                    icon: Icons.insert_chart_outlined_outlined,
                    text: 'Stadistic',
                  ),
                  GButton(
                    icon: Icons.notifications,
                    text: 'Notifications',
                    leading: badge == 0
                        ? null
                        : Badge(
                            label: const Text(
                              "",
                            ),
                            backgroundColor: Colors.red.shade900,
                            child: const Icon(
                              Icons.notifications,
                              color: RecdatStyles.defaultTextColor,
                            ),
                          ),
                  ),
                  const GButton(
                    icon: Icons.settings,
                    text: 'Settings',
                  )
                ]
              : const [
                  GButton(
                    icon: Icons.qr_code,
                    text: 'Qrcode',
                  ),
                  GButton(
                    icon: Icons.list,
                    text: 'Attendance',
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
