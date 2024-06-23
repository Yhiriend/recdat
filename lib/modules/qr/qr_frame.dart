import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRFrame extends StatefulWidget {
  final String qrData;
  const QRFrame({super.key, required this.qrData});

  @override
  State<QRFrame> createState() => _QRFrameState();
}

class _QRFrameState extends State<QRFrame> {
  final GlobalKey _globalKey = GlobalKey();
  String _qrData = "hola";

  @override
  void initState() {
    super.initState();
    _qrData = widget.qrData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: Center(
            child: QrImageView(
              data: _qrData,
              version: QrVersions.auto,
              size: 230.0,
            ),
          ),
        ),
      ],
    );
  }
}
