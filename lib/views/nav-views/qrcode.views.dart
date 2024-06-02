import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/qr/model/qr.model.dart';
import 'package:recdat/modules/qr/qr_frame.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/utils/routes.dart';
import 'package:recdat/utils/utils.dart';

class QrcodeView extends StatefulWidget {
  const QrcodeView({super.key});

  @override
  State<QrcodeView> createState() => _QrcodeViewState();
}

class _QrcodeViewState extends State<QrcodeView> {
  late String lastQRDate;
  late String lastQRData;

  Future<void> generateQRCode(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final UserModel? userData = authProvider.user;
      if (userData!.isComplete() == true) {
        final String currentDate = RecdatDateUtils.currentDate();
        final QRModel qrData = QRModel(
            uid: userData.uid,
            name: userData.name,
            surname: userData.surname,
            email: userData.email ?? "",
            rol: userData.rol ?? "none",
            date: currentDate);
        final String qrDataStringified = jsonEncode(qrData);
        await Future.delayed(const Duration(seconds: 3));
        setState(() {
          lastQRData = qrDataStringified;
          lastQRDate = currentDate;
        });
        showSnackBar(context, "QR actualizado 😉", SnackBarType.success);
      }
      print("STEP 2");
    } catch (e) {
      showSnackBar(context, "Ups! vuelve a intentarlo 😥", SnackBarType.error);
    }
  }

  @override
  void initState() {
    super.initState();
    lastQRDate = "";
    lastQRData = "";
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userRol = authProvider.user?.rol;
    final isAdmin = userRol == UserRole.admin.value;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                Stack(alignment: Alignment.center, children: [
                  Image.asset('assets/images/frameqr.png'),
                  Container(
                    child: lastQRData.isEmpty
                        ? Image.asset('assets/images/recdat_blue.png')
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: QRFrame(qrData: lastQRData),
                          ),
                  )
                ]),
                Positioned(
                    bottom: -5,
                    left: 0,
                    right: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lastQRDate,
                            style: const TextStyle(
                                color: RecdatStyles.blueDarkColor),
                          )
                        ]))
              ],
            ),
            RecdatButtonAsync(
              onPressed: () => generateQRCode(context),
              text: "Generar QR",
            ),
          ],
        ),
      ),
      floatingActionButton: isAdmin
          ? SpeedDial(
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
                    label: "Cursos",
                    onTap: () {
                      Navigator.pushNamed(context, RecdatRoutes.courses);
                    }),
                SpeedDialChild(
                    foregroundColor: RecdatStyles.blueDarkColor,
                    child: const Icon(Icons.groups_rounded),
                    label: "Profesores",
                    onTap: () {
                      Navigator.pushNamed(context, RecdatRoutes.teachers);
                    })
              ],
            )
          : null,
    );
  }
}
