import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import '../constants/colors.dart';
import '../constants/size_config.dart';
import 'package:skinai/appservices/image_picker_service.dart';
import '../views/chat_image_screen.dart';

class FaceScannerDialog extends StatelessWidget {
  const FaceScannerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePickerService imagePickerService = ImagePickerService();

    return AlertDialog(
      backgroundColor: secondaryColor,
      title: Text(
        'Face Scanner',
        style: TextStyle(
          fontSize: SizeConfig.textMultiplier * 2,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
      content: Text(
        'Scan Your Face via',
        style: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1.4,
          fontWeight: FontWeight.w400,
          color: primaryColor,
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text(
              'Gallery',
              style: TextStyle(color: primaryColor),
            ),
            onPressed: () async {
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: SpinKitFadingCircle(
                    color: successColor,
                    size: 50.0,
                  ),
                ),
              );

              // Pick and upload image (0 = Camera, 1 = Gallery)
              final String userImage = await imagePickerService.uploadingImageToFirebase(context, 1);


              // Close FaceScanner dialog
              Navigator.of(context, rootNavigator: true).pop();

              // Navigate to chat screen
              Future.microtask(() {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatWithImageScreen(userImage: userImage),
                  ),
                );
              });
            }
        ),
        TextButton(
            child: const Text(
              'Camera',
              style: TextStyle(color: primaryColor),
            ),
            onPressed: () async {
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: SpinKitFadingCircle(
                    color: successColor,
                    size: 50.0,
                  ),
                ),
              );

              // Pick and upload image (0 = Camera, 1 = Gallery)
              final String userImage = await imagePickerService.uploadingImageToFirebase(context, 0);

              // Dismiss loading dialog
              Navigator.of(context, rootNavigator: true).pop(); // Dismiss loader

              // Close FaceScanner dialog
              Navigator.of(context, rootNavigator: true).pop();

              // Navigate to chat screen
              Future.microtask(() {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatWithImageScreen(userImage: userImage),
                  ),
                );
              });
            }
        ),
      ],
    );
  }
}
