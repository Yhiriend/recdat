import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/attendance/views/attendance.view.dart';
import 'package:recdat/modules/qr/qr_frame.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_alert.dart';
import 'package:recdat/shared/widgets/recdat_navbar.dart';
import 'package:recdat/views/admin_notifications.view.dart';
import 'package:recdat/views/nav-views/qrcode.views.dart';
import 'package:recdat/views/settings.view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userRol = authProvider.user?.rol;
    final isAdmin = userRol == UserRole.admin.value;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: RecdatStyles.blueDarkColor,
          title: Text(
            authProvider.user?.rol ?? "",
            style: const TextStyle(color: RecdatStyles.defaultTextColor),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await authProvider.syncUserDataByUid(
                      context, authProvider.uid);
                },
                icon: const Icon(
                  Icons.sync,
                  color: RecdatStyles.defaultTextColor,
                )),
            IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => RecdatAlert(
                            title: "Cerrar sesion",
                            message:
                                "Estas seguro de querer cerrar la sesion actual?",
                            onSubmit: () async {
                              await authProvider.signOut(context);
                            },
                            buttonText: "Si, salir",
                            alertType: "warning",
                          ));
                },
                icon: const Icon(
                  Icons.logout,
                  color: RecdatStyles.defaultTextColor,
                ))
          ],
        ),
        body: isAdmin
            ? IndexedStack(
                index: _selectedIndex,
                children: [
                  Container(
                    color: RecdatStyles.whiteColor,
                    child: const Center(
                      child: QrcodeView(),
                    ),
                  ),
                  Container(
                    color: Colors.green,
                    child: const Center(
                      child: QRFrame(
                        qrData: "hello",
                      ),
                    ),
                  ),
                  Container(
                    color: RecdatStyles.whiteColor,
                    child: AdminNotificationsView(),
                  ),
                  Container(
                    color: RecdatStyles.whiteColor,
                    child: SettingsView(),
                  ),
                ],
              )
            : IndexedStack(
                index: _selectedIndex,
                children: [
                  Container(
                    color: RecdatStyles.whiteColor,
                    child: const Center(
                      child: QrcodeView(),
                    ),
                  ),
                  Container(
                    color: RecdatStyles.whiteColor,
                    child: const AttendanceView(),
                  ),
                  Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Text('Notifications'),
                    ),
                  ),
                  Container(
                    color: RecdatStyles.whiteColor,
                    child: SettingsView(),
                  ),
                ],
              ),
        bottomNavigationBar: RecdatNavbar(
          onTabChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
