import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';
import 'package:recdat/utils/hasher.dart';
import 'package:recdat/utils/local_notifications.dart';
import 'package:recdat/utils/utils.dart';
import 'dart:core';

import 'package:recdat/views/home.view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  bool _isCodePhoneValidated = false;
  bool _codeSent = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    emailController.dispose();
    nameController.dispose();
    surnameController.dispose();
    instituteController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isCodePhoneValidated = false;
    _codeSent = false;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearPreferences();
  }

  Future<void> sendPhoneCode() async {
    if (_formKey.currentState!.validate()) {
      final ap = Provider.of<AuthProvider>(context, listen: false);
      String phoneNumber = "+57${phoneController.text.trim()}";
      await ap.signInWithPhone(context, phoneNumber).then((_) {
        LocalNotifications.showSimpleNotification(
            title: "Código de verificación",
            body: "586691 es su código de verificación",
            payload: "payload");
        setState(() {
          _codeSent = true;
        });
      });
      //await Future.delayed(const Duration(seconds: 3));
    }
  }

  Future<void> validatePhoneCode() async {
    if (_formKey.currentState!.validate()) {
      final ap = Provider.of<AuthProvider>(context, listen: false);
      final verificationId = ap.verificationId;
      ap.verifyOtp(
          context: context,
          verificationId: verificationId,
          userOtp: codeController.text.trim(),
          onSuccess: () {
            ap.checkExistingUser().then((value) async {
              if (value == true) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeView(),
                    ),
                    (route) => false);
              } else {
                setState(() {
                  _isCodePhoneValidated = true;
                });
              }
            });
          });
      //await Future.delayed(const Duration(seconds: 3));
    }
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      await storeData();
    }
  }

  Future<void> storeData() async {
    setState(() {
      _isLoading = true;
    });
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
        uid: "",
        name: nameController.text.trim().toUpperCase(),
        surname: surnameController.text.trim().toUpperCase(),
        lastSurname: "",
        email: emailController.text.trim().toLowerCase(),
        phone: phoneController.text.trim(),
        rol: UserRole.admin.value,
        isActive: true,
        createdAt: RecdatDateUtils.currentDate().toString(),
        password: hashPassword(passwordController.text.trim()));
    ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        onSuccess: () {
          setState(() {
            _isLoading = false;
          });
          ap.createInstitute(context, instituteController.text.trim(), () {
            ap.saveUserDataToSP().then((value) =>
                ap.setSignIn().then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeView(),
                    ),
                    (route) => false)));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    //final isLoading =
    Provider.of<AuthProvider>(context, listen: true).isLoading;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF003366),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
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
              const SizedBox(
                height: 40,
              ),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _isCodePhoneValidated
                      ? Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Column(
                                  children: [
                                    RecdatTextfield(
                                      controller: nameController,
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
                                      controller: surnameController,
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
                                      controller: emailController,
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
                                      controller: passwordController,
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
                                      controller: instituteController,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: RecdatButtonAsync(
                                  onPressed: () => signUp(),
                                  text: "Registrarse",
                                ),
                              ),
                            ],
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
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
                                      type: TextInputType.number,
                                      controller: phoneController,
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
                                                type: TextInputType.number,
                                                controller: codeController,
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
                              const SizedBox(
                                height: 40,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: RecdatButtonAsync(
                                  onPressed: _codeSent
                                      ? () => validatePhoneCode()
                                      : () => sendPhoneCode(),
                                  text: _codeSent ? "Validar" : "Enviar código",
                                ),
                              ),
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  PopScope(
                                    canPop: false,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Ya tengo una cuenta",
                                          style: TextStyle(
                                              color: Color(0xBFCCCCCC)),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
