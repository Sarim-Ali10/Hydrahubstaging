import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/size_config.dart';

class ProductContainer extends StatelessWidget {
  const ProductContainer({
    super.key,
    required this.productImage,
    required this.productTitle,
    required this.productCategory,
    required this.productPrice,
    required this.productAvailability,
  });

  final String productImage;
  final String productTitle;
  final String productCategory;
  final String productPrice;
  final String productAvailability;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 1,
      height: SizeConfig.screenHeight * 0.15,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          // Image Container
          Container(
            width: SizeConfig.screenWidth * 0.25,
            height: SizeConfig.screenHeight * 0.13,
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 10,
                      color: primaryColor.withOpacity(0.08)
                  )
                ],
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(productImage))
            ),
          ),

          SizedBox(
            width: SizeConfig.widthMultiplier * 4,
          ),

          // Product Detail Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(productCategory,style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.65, fontWeight: FontWeight.w600,color: primaryColor.withOpacity(0.6)),),

              SizedBox(
                height: SizeConfig.heightMultiplier * 0.6,
              ),

              SizedBox(
                  width: SizeConfig.screenWidth * 0.6,
                  child: Text(productTitle,style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.2, fontWeight: FontWeight.w800,color: primaryColor),overflow: TextOverflow.fade,)),

              SizedBox(
                height: SizeConfig.heightMultiplier * 0.6,
              ),

              Row(
                children: [
                  Text(productPrice,style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.65, fontWeight: FontWeight.w600,color: primaryColor.withOpacity(0.4)),),

                  SizedBox(
                    width: SizeConfig.widthMultiplier * 2,
                  ),

                  Container(
                    width: SizeConfig.screenWidth * 0.02,
                    height: SizeConfig.screenHeight * 0.02,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: productAvailability == "In Stock" ? successColor : dangerColor
                    ),
                  ),

                  SizedBox(
                    width: SizeConfig.widthMultiplier * 2,
                  ),

                  Text(productAvailability,style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.65, fontWeight: FontWeight.w600,color: productAvailability == "In Stock" ? successColor : dangerColor),),


                ],
              ),

            ],
          )

        ],
      ),
    );
  }
}
