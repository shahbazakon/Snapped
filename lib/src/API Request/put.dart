import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class editProfileDetails {

  PickedFile? profilePick;
  String? UsernameController;
  String? EmailController;
  String? PasswordController;


  editProfileDetails(
      this.profilePick,
      this.UsernameController,
      this.EmailController,
      this.PasswordController,
      );

  editDetails(userId) async {

    print("edit Profile Details Called");
    print("editDetails: https://snapped.kiska.co.in/user/edit/$userId");

    String fileName = profilePick!.path.split('/').last;
    print('PATH: ${profilePick!.path}');
    print('IMAGE NAME : $fileName');


    try {

      // FormData formData = FormData.fromMap({
      //   "img": await MultipartFile.fromFile(
      //     profilePick!.path,
      //     filename: fileName,
      //   ),
      //   'username': UsernameController,
      //   'email' : EmailController,
      //   'password' : PasswordController,
      // });

      var formData = {
      'username': UsernameController,
      'email' : EmailController,
      'password' : PasswordController,
       'img': await MultipartFile.fromFile(
          profilePick!.path,
          filename: fileName,
          contentType: MediaType("image", fileName.split(".").last),
        ),
      };
      var res = await Dio()
          .put('https://snapped.kiska.co.in/user/edit/$userId',
          data: formData)
          .then((response) {
        response.statusCode == 200
            ? print("successful edit Profile Details ")
            : print("pset request is fail");
      });
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.message);
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response);
      } else {
        print("fail");
        print(e.message);
      }
    }
  }
}