import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinai/constants/colors.dart';
import 'package:skinai/constants/size_config.dart';

class ImagePickerService{

  static void customMessage(BuildContext context, String message, int type){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        elevation: 0,
        duration: const Duration(seconds: 6),
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        content: Container(
      decoration: BoxDecoration(
        color: type == 1 ? dangerColor : accentColor,
        borderRadius: BorderRadius.circular(14)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: Row(
        children: [

          Icon(type == 1 ? Iconsax.danger : Iconsax.magicpen, size: 20, color: secondaryColor,),

          SizedBox(width: SizeConfig.widthMultiplier * 2,),

          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: Text(message,style: TextStyle(
              color: secondaryColor,
              fontSize: SizeConfig.textMultiplier * 1.5,
              fontWeight: FontWeight.w600
            ),textAlign: TextAlign.left,overflow: TextOverflow.fade, maxLines: 3,),
          ),
        ],
      ),
    )));
  }

  static String testDescription = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";


  Future uploadingImageToFirebase(BuildContext context, int type)async{
    XFile? image = await ImagePicker().pickImage(source: type == 0 ? ImageSource.camera : ImageSource.gallery);
    if(image != null){
      File convertedImage = File(image.path);
      // customMessage(context, "Analyzing Images", 0);
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("ImageForAI").child(DateTime.now().toString()).putFile(convertedImage);
      TaskSnapshot taskSnapshot = await uploadTask;
      String userImage = await taskSnapshot.ref.getDownloadURL();
      debugPrint("UserImage Uploaded: $userImage");
      return userImage;
    } else{
      customMessage(context, "message", 1);
    }
  }
  Future analyzeImageWithOpenAI(BuildContext context, String userImage, {String prompt = "Please analyze this skin condition"}) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://hydra-hub-mf38ztuwu-touseef-ahmeds-projects.vercel.app/api/ai/analyze'),
    );
    request.body = json.encode({
      "imageUrl": userImage,
      "message": prompt,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}