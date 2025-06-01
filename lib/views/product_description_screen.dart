import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinai/constants/colors.dart';
import 'package:skinai/constants/size_config.dart';

class ProductDescriptionScreen extends StatefulWidget {
  const ProductDescriptionScreen({
    super.key,
    required this.image,
    required this.title,
    required this.stock,
    required this.productPrice,
    required this.description, // ✅ Step 1: Add to constructor
  });

  final String image;
  final String title;
  final String stock;
  final int productPrice;
  final String description;

  @override
  State<ProductDescriptionScreen> createState() =>
      _ProductDescriptionScreenState();
}

class _ProductDescriptionScreenState extends State<ProductDescriptionScreen> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        top: true,
        child: Container(
          width: SizeConfig.screenWidth * 1,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.heightMultiplier * 2),
              Stack(
                children: [
                  // Background Support Container
                  SizedBox(
                    width: SizeConfig.screenWidth * 1,
                    height: SizeConfig.screenHeight * 0.38,
                  ),

                  // Image Container
                  Container(
                    width: SizeConfig.screenWidth * 1,
                    height: SizeConfig.screenHeight * 0.38,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.image),
                      ),
                    ),
                  ),

                  // Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Iconsax.arrow_left,
                          color: primaryColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),

                  Positioned(
                    top: 240,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            widget.stock == "In Stock"
                                ? successColor
                                : dangerColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        widget.stock,
                        style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 1.4,
                          fontWeight: FontWeight.w800,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.heightMultiplier * 2),

              SizedBox(
                // height: SizeConfig.screenHeight * 0.07,
                width: SizeConfig.screenWidth * 0.8,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 2.5,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),

              SizedBox(height: SizeConfig.heightMultiplier * 2),

              Text(
                'Description:',
                style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 1.6,
                  fontWeight: FontWeight.w400,
                  color: primaryColor.withValues(alpha: 0.6),
                ),
              ),

              Container(
                width: SizeConfig.screenWidth * 0.95,
                height: SizeConfig.screenHeight * 0.336,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Text(widget.description),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
