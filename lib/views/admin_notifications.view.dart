import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:recdat/shared/widgets/recdat_input_date.dart';

class AdminNotificationsView extends StatefulWidget {
  final TextEditingController filterDate = TextEditingController();
  AdminNotificationsView({
    super.key,
  });

  @override
  State<AdminNotificationsView> createState() => _AdminNotificationsViewState();
}

final databaseReference = FirebaseDatabase.instance.ref();

class _AdminNotificationsViewState extends State<AdminNotificationsView> {
  TextEditingController _filterDate = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(115, 0, 0, 0), width: 1.0))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Filtrar desde:",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RecdatInputDate(
                          placeholder: "Selecciona una fecha",
                          controller: _filterDate),
                    ),
                  ],
                ),
              ),
            ),
            FirebaseAnimatedList(
                query: databaseReference,
                itemBuilder: (context, snapshot, index, animation) {
                  return ListTile(
                    title: Text("wath"),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget content() {
    print("DATA REALTIME: ");
    return Text("data");
  }
}
