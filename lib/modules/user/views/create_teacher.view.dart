import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_multiselect.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';

class CreateTeacherView extends StatefulWidget {
  const CreateTeacherView({super.key});

  @override
  State<CreateTeacherView> createState() => _CreateTeacherViewState();
}

class _CreateTeacherViewState extends State<CreateTeacherView> {
  final TextEditingController coursesController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController selectorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            foregroundColor: RecdatStyles.defaultTextColor,
            title: const Text(
              "Nuevo registro de profesor",
              style: TextStyle(color: RecdatStyles.defaultTextColor),
            ),
            backgroundColor: RecdatStyles.blueDarkColor,
          ),
          backgroundColor: RecdatStyles.backPageWhiteColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Center(
                  child: Icon(
                    Icons.person,
                    size: 150.0,
                  ),
                ),
                Column(
                  children: [
                    RecdatTextfield(
                      placeholder: "Nombre",
                      controller: nameController,
                      color: RecdatStyles.textFieldLight,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RecdatTextfield(
                        placeholder: "Apellido",
                        controller: surnameController,
                        color: RecdatStyles.textFieldLight),
                    const SizedBox(
                      height: 20,
                    ),
                    RecdatTextfield(
                        placeholder: "Correo",
                        controller: emailController,
                        color: RecdatStyles.textFieldLight),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                RecdatButtonAsync(
                  onPressed: () async {
                    //asdf
                  },
                  text: "Registrar profesor",
                )
              ],
            ),
          )),
    );
  }
}
