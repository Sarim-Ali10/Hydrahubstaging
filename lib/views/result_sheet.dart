// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:skinai/appservices/image_picker_service.dart';
// import '../constants/colors.dart';
// import '../constants/size_config.dart';
// import 'doctors_screen.dart';
//
// class ResultSheet extends StatelessWidget {
//   const ResultSheet({super.key, required this.userImage});
//
//   final String userImage;
//
//   @override
//   Widget build(BuildContext context) {
//     final ImagePickerService imagePickerService = ImagePickerService();
//     return Scaffold(
//       body: FutureBuilder(future: imagePickerService.analyzeImageWithOpenAI(context, userImage), builder: (context, snapshot) {
//
//         if(snapshot.connectionState == ConnectionState.waiting){
//           return Center(child: Text("Processing your Image"),
//           );
//         }
//
//         else if(snapshot.hasData){
//
//           var response = jsonDecode(snapshot.data);
//           String aiResult = response["data"]["analysis"];
//
//           return Container(
//           constraints: BoxConstraints(
//             minWidth: SizeConfig.screenWidth * 1,
//             maxWidth: SizeConfig.screenWidth * 1,
//             minHeight: SizeConfig.screenHeight * 0.8,
//             maxHeight: SizeConfig.screenHeight * 0.8,
//           ),
//           decoration: BoxDecoration(
//               color: secondaryColor,
//               borderRadius: BorderRadius.circular(20)
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               SizedBox(height: SizeConfig.heightMultiplier * 2,),
//
//               Container(
//                 width: SizeConfig.screenWidth * 1,
//                 height: SizeConfig.screenHeight * 0.25,
//                 alignment: Alignment.bottomLeft,
//                 padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     image: DecorationImage(
//                         fit: BoxFit.cover,
//                         colorFilter: ColorFilter.mode(primaryColor.withValues(alpha:0.4), BlendMode.darken),
//                         image: NetworkImage(userImage))
//                 ),
//                 child: Text("Generated Result",style: TextStyle(
//                     fontSize: SizeConfig.textMultiplier * 2.2,
//                     color: secondaryColor,
//                     fontWeight: FontWeight.bold
//                 ),),
//               ),
//
//               SizedBox(height: SizeConfig.heightMultiplier * 2,),
//
//               Text("Image Description",style: TextStyle(
//                   fontSize: SizeConfig.textMultiplier * 2.2,
//                   color: primaryColor,
//                   fontWeight: FontWeight.bold
//               ),),
//
//               SizedBox(height: SizeConfig.heightMultiplier * 2,),
//
//               Container(
//                 height: SizeConfig.screenHeight * 0.2,
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: SingleChildScrollView(
//                   physics: const ScrollPhysics(),
//                   child: Text(aiResult,style: TextStyle(
//                       fontSize: SizeConfig.textMultiplier * 1.6,
//                       color: primaryColor,
//                       fontWeight: FontWeight.w400
//                   ),),
//                 ),
//               ),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ElevatedButton(
//                       style: const ButtonStyle(
//                           backgroundColor: WidgetStatePropertyAll(accentColor)
//                       ),
//                       onPressed: (){}, child: Text("Suggest Products",style: TextStyle(
//                       fontSize: SizeConfig.textMultiplier * 1.4,
//                       color: secondaryColor,
//                       fontWeight: FontWeight.w400
//                   ),)),
//                   ElevatedButton(
//                       style: const ButtonStyle(
//                           backgroundColor: WidgetStatePropertyAll(accentColor)
//                       ),
//                       onPressed: (){
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => AllDoctorsScreen(),));
//                       }, child: Text("Suggest Doctors",style: TextStyle(
//                       fontSize: SizeConfig.textMultiplier * 1.4,
//                       color: secondaryColor,
//                       fontWeight: FontWeight.w400
//                   ),))
//                 ],
//               )
//
//             ],
//           ),
//         );
//         }
//
//         else{
//           return Center(child: Icon(Icons.error),);
//         }
//
//       },),
//     );
//   }
// }
