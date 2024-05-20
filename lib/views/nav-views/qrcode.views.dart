import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:recdat/modules/qr/qr_frame.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/utils/routes.dart';

class QrcodeView extends StatefulWidget {
  const QrcodeView({super.key});

  @override
  State<QrcodeView> createState() => _QrcodeViewState();
}

class _QrcodeViewState extends State<QrcodeView> {
  late String lastQRDate;

  Future<void> generateQRCode(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      lastQRDate = DateTime.now().toString().split('.')[0];
    });
  }

  @override
  void initState() {
    super.initState();
    lastQRDate = "";
  }

  @override
  Widget build(BuildContext context) {
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
                    child: lastQRDate.isEmpty
                        ? Image.asset('assets/images/recdat_blue.png')
                        : QRFrame(qrData: lastQRDate),
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
      floatingActionButton: SpeedDial(
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
                Navigator.pushNamed(context, RecdatRoutes.createTeacher);
              })
        ],
      ),
    );
  }
}
