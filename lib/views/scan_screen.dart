import 'package:flutter/material.dart';

import '../reuseablewidgets/face_scanner_dialog.dart';
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dialogShown) {
      _dialogShown = true;
      Future.microtask(() {
        showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return const FaceScannerDialog();
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can return a placeholder screen here
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Face Scanner"),
      ),
    );
  }
}
