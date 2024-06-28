import 'package:flutter/material.dart';

class CardAdminNotification extends StatelessWidget {
  final String title;
  final String message;
  final String timestamp;
  const CardAdminNotification({
    super.key,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [Image.asset("assets/images/default_avatar.jpg")],
          ),
          const Column(
            children: [
              Text("Titulo de notification"),
              Text("El profesor Guillermo ha realizo su registro."),
              Text("hace 2 horas"),
            ],
          )
        ],
      ),
    );
  }
}
