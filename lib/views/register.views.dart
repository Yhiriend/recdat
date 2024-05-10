import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';
import 'dart:core';

class RegisterView extends StatefulWidget {
  RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  bool _isCodePhoneValidated = false;
  bool _codeSent = false;

  @override
  void initState() {
    super.initState();
    _isCodePhoneValidated = false;
    _codeSent = false;
  }

  Future<void> sendPhoneCode() async {
    if (_formKey.currentState!.validate()) {
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        _codeSent = true;
      });
    }
  }

  Future<void> validatePhoneCode() async {
    if (_formKey.currentState!.validate()) {
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        _isCodePhoneValidated = true;
      });
    }
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/home');
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
              top: -MediaQuery.of(context).size.height * 0.25,
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
                    "REGISTRO DE ADMINISTRADOR",
                    style: TextStyle(
                        color: Color(0xFFCCCCCC), fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
            _isCodePhoneValidated
                ? Positioned.fill(
                    top: MediaQuery.of(context).size.height * 0.2,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              children: [
                                RecdatTextfield(
                                  placeholder: "nombre",
                                  icon: Icons.person,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Introduce tu nombre";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                RecdatTextfield(
                                  placeholder: "apellido",
                                  icon: Icons.person,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Introduce tu apellido";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                RecdatTextfield(
                                  placeholder: "correo",
                                  icon: Icons.mail,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Introduce un correo válido";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                RecdatTextfield(
                                  placeholder: "contraseña",
                                  icon: Icons.lock,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Introduce una constraseña";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                RecdatTextfield(
                                  placeholder: "institución",
                                  icon: Icons.school,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Introduce tu institución";
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: RecdatButtonAsync(
                              onPressed: () => signUp(),
                              text: "Registrarse",
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Positioned.fill(
                    top: MediaQuery.of(context).size.height * 0.2,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.phone_iphone_rounded,
                                  color: RecdatStyles.defaultTextColor,
                                  size: 150,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                RecdatTextfield(
                                  placeholder: "número de teléfono",
                                  icon: Icons.phone,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Ingresa un teléfono válido";
                                    }
                                    return null;
                                  },
                                ),
                                _codeSent
                                    ? Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          RecdatTextfield(
                                            placeholder: "código",
                                            icon: Icons.numbers,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Ingresa un código válido";
                                              }
                                              return null;
                                            },
                                          )
                                        ],
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: RecdatButtonAsync(
                              onPressed: _codeSent
                                  ? () => validatePhoneCode()
                                  : () => sendPhoneCode(),
                              text: _codeSent ? "Validar" : "Enviar código",
                            ),
                          ),
                          Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: const Text(
                                    "Ya tengo una cuenta",
                                    style: TextStyle(color: Color(0xBFCCCCCC)),
                                  )),
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
