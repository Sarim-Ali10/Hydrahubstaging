import 'package:flutter/material.dart';
import 'package:skinai/reuseablewidgets/face_scanner_dialog.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FaceScannerDialog();
  }
}
