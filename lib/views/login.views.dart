import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';
import 'package:recdat/utils/utils.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await Future.delayed(const Duration(seconds: 3));
      final ap = Provider.of<AuthProvider>(context, listen: false);
      ap
          .signInWithEmailAndPassword(
              context, _username.text.trim(), _password.text.trim())
          .then((value) => {showSnackBar(context, "Has iniciado sesion")});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF003366),
        body: Stack(
          children: [
            Positioned(
              top: -80,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  FractionalTranslation(
                    translation: const Offset(0.5, 0.0),
                    child: Image.asset('assets/images/logo_recdat.png'),
                  ),
                  const Row(
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
                  const Text(
                    "MÁS FÁCIL Y MÁS RÁPIDO",
                    style: TextStyle(
                        color: Color(0xFFCCCCCC), fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.3,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: [
                          RecdatTextfield(
                            controller: _username,
                            placeholder: "usuario",
                            icon: Icons.person,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Ingresa tu usuario";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RecdatTextfield(
                            controller: _password,
                            placeholder: "contraseña",
                            icon: Icons.lock,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Ingresa tu contraseña";
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RecdatButtonAsync(
                        onPressed: () => login(context),
                        text: "Entrar",
                      ),
                    ),
                    Column(
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              "¿Olvidaste tu contraseña?",
                              style: TextStyle(color: Color(0xBFCCCCCC)),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              "Registrarse como administrador",
                              style: TextStyle(color: Color(0xBFCCCCCC)),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
