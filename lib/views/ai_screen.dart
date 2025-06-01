import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/colors.dart';
import '../constants/size_config.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key,
  required this.diseaseImage,
  required this.diseaseTitle,
  required this.diseaseDescription,
  required this.diseaseCause,
  required this.diseaseCure,
  required this.diseaseTime,
  required this.diseaseCautions,
  });
  final File diseaseImage;
  final String diseaseTitle;
  final String diseaseDescription;
  final String diseaseCause;
  final String diseaseCure;
  final String diseaseTime;
  final String diseaseCautions;

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Image Container
                  Stack(
                    children: [

                      // Background Support Container

                      SizedBox(
                        width: SizeConfig.screenWidth * 1,
                        height: SizeConfig.screenHeight * 0.2,
                      ),

                      // Image Container
                      Container(
                        width: SizeConfig.screenWidth * 1,
                        height: SizeConfig.screenHeight * 0.38,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(widget.diseaseImage)),
                        ),
                      ),

                      // Icons
                      Row(
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: const Icon(Iconsax.arrow_left,color: primaryColor,size: 30,)),
                        ],
                      ),
                    ],
                  ),

              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),

              Text('Title:',style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.8, fontWeight: FontWeight.w600,color: primaryColor.withOpacity(0.4)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.diseaseTitle,style: TextStyle(fontSize: SizeConfig.textMultiplier * 2, fontWeight: FontWeight.w600,color: primaryColor))),

                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),


                  Text('Description: ',style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.8, fontWeight: FontWeight.w600,color: primaryColor.withOpacity(0.4)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.diseaseDescription,style: TextStyle(fontSize: SizeConfig.textMultiplier * 2, fontWeight: FontWeight.w600,color: primaryColor))),

                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),


                  Text('Cause: ',style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.8, fontWeight: FontWeight.w600,color: primaryColor.withOpacity(0.4)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.diseaseCause,style: TextStyle(fontSize: SizeConfig.textMultiplier * 2, fontWeight: FontWeight.w600,color: primaryColor))),

                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),


                  Text('Cure: ',style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.8, fontWeight: FontWeight.w600,color: primaryColor.withOpacity(0.4)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.diseaseCure,style: TextStyle(fontSize: SizeConfig.textMultiplier * 2, fontWeight: FontWeight.w600,color: primaryColor))),


                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),


                  Text('Time to Cure: ',style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.8, fontWeight: FontWeight.w600,color: primaryColor.withOpacity(0.4)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.diseaseTime,style: TextStyle(fontSize: SizeConfig.textMultiplier * 2, fontWeight: FontWeight.w600,color: primaryColor))),

                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),


                  Text('Pre Cautions: ',style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.8, fontWeight: FontWeight.w600,color: primaryColor.withOpacity(0.4)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.diseaseCautions,style: TextStyle(fontSize: SizeConfig.textMultiplier * 2, fontWeight: FontWeight.w600,color: primaryColor))),

                ],
              ),
            ),
          )),
    );
  }
}
