import 'package:dio/dio.dart';

class editProfileDetails {

  String? UsernameController;
  String? EmailController;
  String? PasswordController;


  editProfileDetails(
      this.UsernameController,
      this.EmailController,
      this.PasswordController,
      );

  editDetails(userId) async {

    print("edit Profile Details Called");
    print("editDetails: https://snapped.kiska.co.in/user/edit/$userId");

    try {
      var formData = {
        'username': UsernameController,
        'email' : EmailController,
        'password' : PasswordController,

      };

      var res = await Dio()
          .put('https://snapped.kiska.co.in/user/edit/$userId',
          data: formData)
          .then((response) {
        response.statusCode == 200
            ? print("successful edit Profile Details ")
            : print("fail");
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