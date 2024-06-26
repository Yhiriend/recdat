import 'package:flutter/material.dart';
import 'package:recdat/shared/widgets/recdat_dropdown.dart';
import 'package:recdat/shared/widgets/recdat_input_date.dart';
import 'package:recdat/utils/utils.dart';

class AdminNotificationsView extends StatefulWidget {
  final TextEditingController filterDate = TextEditingController();
  AdminNotificationsView({super.key});

  @override
  State<AdminNotificationsView> createState() => _AdminNotificationsViewState();
}

class _AdminNotificationsViewState extends State<AdminNotificationsView> {
  TextEditingController _filterDate = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Filtrar desde",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RecdatInputDate(
                    placeholder: "Selecciona una fecha",
                    controller: _filterDate),
              )
            ],
          )
        ],
      ),
    );
  }
}
