import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/qr/qr_frame.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_navbar.dart';
import 'package:recdat/views/nav-views/qrcode.views.dart';

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
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: RecdatStyles.blueDarkColor,
          title: Text(
            ap.user?.name ?? "",
            style: const TextStyle(color: RecdatStyles.defaultTextColor),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout,
                  color: RecdatStyles.defaultTextColor,
                ))
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            Container(
              color: RecdatStyles.defaultColor,
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
              color: Colors.blue,
              child: const Center(
                child: Text('Notifications'),
              ),
            ),
            Container(
              color: Colors.yellow,
              child: const Center(
                child: Text('Settings'),
              ),
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
