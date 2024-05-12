import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/views/home.views.dart';
import 'package:recdat/views/login.views.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  Future<void> checkAuthentication(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    final ap = Provider.of<AuthProvider>(context, listen: false);
    if (!ap.isSignedIn) {
      Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
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
