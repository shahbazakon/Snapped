import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';


class editProfilePick {

  PickedFile? profilePick;
  String? Username;
  String? Email;
  String? oldPasswordController;

  editProfilePick(
      this.profilePick,
      this.Username,
      this.Email,
      this.oldPasswordController,
      );

  editDetails(userId) async {

    print("edit Profile Picture Called".toUpperCase());
    print("edit Picture: http://snapped.kiska.co.in/user/edit/$userId");

    String fileName = profilePick!.path.split('/').last;
    print('PATH: ${profilePick!.path}');
    print('IMAGE NAME : $fileName');


    try {
      var image = await MultipartFile.fromFile(
        profilePick?.path ?? '',
        filename: profilePick?.path.split('/').last,
        // contentType: MediaType("image", fileName.split(".").last),
      );
      var formData = FormData.fromMap({
        'image': image,
        'username': Username,
        'email' : Email,
        'password' : oldPasswordController,
        'newpassword' : '',
        'password' : oldPasswordController,
      });
      var res = await Dio()
          .put('http://snapped.kiska.co.in/user/edit/$userId',
          data: formData)
          .then((response) {
        response.statusCode == 200
            ? print("successful edit Profile Picture \n RESPONSE: ${response.data} ".toUpperCase())
            : print("post request is fail".toUpperCase());

        print("Responce Code :  <${response.data}> ${response.data.runtimeType}".toUpperCase());
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

class editInfoDetails {
  String? UsernameController;
  String? EmailController;
  String? newPasswordController;
  String? oldPasswordController;

  editInfoDetails(
      this.UsernameController,
      this.EmailController,
      this.newPasswordController,
      this.oldPasswordController
      );

  editDetails(userId) async {

    print("edit information Details Called".toUpperCase());
    print("editDetails: http://snapped.kiska.co.in/user/edit/$userId");
    try {

      var formData = FormData.fromMap({
        'username': UsernameController,
        'email' : EmailController,
        'password' : oldPasswordController,
        'newpassword' : newPasswordController,
      });
      var res = await Dio()
          .put('http://snapped.kiska.co.in/user/edit/$userId',
          data: formData)
          .then((response) {
        response.statusCode == 200
            ? print("successful edit information Details \n RESPONSE: ${response.data} ".toUpperCase())
            : print("post request is fail".toUpperCase());

        print("Response Code :  ${response.data} ".toUpperCase());
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