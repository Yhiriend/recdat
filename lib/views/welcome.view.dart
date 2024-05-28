import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/views/home.view.dart';
import 'package:recdat/views/login.view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  Future<void> checkAuthentication(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    final ap = Provider.of<AuthProvider>(context, listen: false);
    if (ap.uid.isEmpty) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String uid = authProvider.uid;
    print("USER AT WELCOME VIEW: $uid");
    if (uid.isNotEmpty) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: RecdatStyles.blueDarkColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FractionalTranslation(
                translation: const Offset(0.0, 0.0),
                child: Image.asset('assets/images/logo_recdat.png'),
              ),
              const Column(
                children: [
                  Text(
                    "Bienvenido a",
                    style: TextStyle(color: RecdatStyles.defaultTextColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "REC",
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCCCCCC)),
                      ),
                      Text(
                        "DAT",
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w100,
                            color: Color(0xFFCCCCCC)),
                      )
                    ],
                  ),
                ],
              ),
              RecdatButtonAsync(
                onPressed: () => checkAuthentication(context),
                text: "Iniciar",
              )
            ],
          ),
        ),
      ),
    );
  }
}
