import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../constants/colors.dart';
import '../constants/size_config.dart';
import 'face_scanner_dialog.dart'; // import the new dialog widget here

class FaceScanningContainer extends StatelessWidget {
  const FaceScanningContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 1,
      height: SizeConfig.screenHeight * 0.25,
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: 20, bottom: 40, right: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(14),
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("images/ai.gif"),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: SizeConfig.screenWidth * 0.45,
            child: Text(
              'Scan Your Face and Get Solutions',
              style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2,
                fontWeight: FontWeight.w600,
                color: secondaryColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return const FaceScannerDialog();
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.user,
                    size: 14,
                  ),
                  SizedBox(
                    width: SizeConfig.widthMultiplier * 2,
                  ),
                  Text(
                    'Scan',
                    style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.4,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
