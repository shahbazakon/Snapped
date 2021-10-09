import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class editProfileDetails {

  PickedFile? profilePick;
  String? UsernameController;
  String? EmailController;
  String? newPasswordController;
  String? oldPasswordController;

  editProfileDetails(
      this.profilePick,
      this.UsernameController,
      this.EmailController,
      this.newPasswordController,
      this.oldPasswordController
      );

  editDetails(userId) async {

    print("edit Profile Details Called".toUpperCase());
    print("editDetails: https://snapped.kiska.co.in/user/edit/$userId");

    String fileName = profilePick!.path.split('/').last;
    print('PATH: ${profilePick!.path}');
    print('IMAGE NAME : $fileName');


    try {

      // List<int> imageBytes = await profilePick!.readAsBytes();
      // String base64Image = base64Encode(imageBytes);
      // print('IMAGE : $base64Image');

      var formData = FormData.fromMap({
      'username': UsernameController,
      'email' : EmailController,
      'password' : oldPasswordController,
      'newpassword' : newPasswordController,
       // 'img': base64Image
      'image':await MultipartFile.fromFile(
          profilePick!.path,
          filename: profilePick!.path.split('/').last,
          // contentType: MediaType("image", fileName.split(".").last),
        ),
      });
      var res = await Dio()
          .put('https://snapped.kiska.co.in/user/edit/$userId',
          data: formData)
          .then((response) {
        response.statusCode == 200
            ? print("successful edit Profile Details \n RESPONSE: ${response.data} ".toUpperCase())
            : print("post request is fail".toUpperCase());

        print("Responce Code :  ${response.data} ".toUpperCase());
        return response.data;

          });
      return res;
    }

    on DioError catch (e) {
      if (e.response != null) {
        print(e.message);
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response);
      } else {
        print("Dio Error Occur");
        print(e.message);
      }
    }
  }
}