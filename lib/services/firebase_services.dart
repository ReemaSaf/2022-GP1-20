import 'dart:io';


import 'package:get/get.dart';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:sekkah_app/Profile/widgets/show_loading_dialoges.dart';

//Firebase function which is used to upload image to firebase.It takes image file and folder name as input and give us String image Path.

class FirebaseStorageServices {
  static Future<String> uploadToStorage(
      {required File file,
      required String folderName,
      bool showDialog = true}) async {
    showDialog ? showLoadingDialog(message: "Processing...") : null;
    try {

      //This Shows Storage reference where image will store on firebase storage 
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
            '$folderName/file${DateTime.now().millisecondsSinceEpoch}',
          );
      //Here we give file which will upload 
      final UploadTask uploadTask = firebaseStorageRef.putFile(file);
      //it will give a tasksnapshot 
      final TaskSnapshot downloadUrl = await uploadTask;
    //Convert task snapshot into string url
      String url = await downloadUrl.ref.getDownloadURL();
      showDialog ? hideLoadingDialog() : null;
      return url; // return  Uploaded Url
    } on Exception catch (e) {
      showDialog ? hideLoadingDialog() : null;
      Get.snackbar('Error', e.toString());
      return "";
    }
  }
}