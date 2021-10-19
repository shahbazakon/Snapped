import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LogIn {
  String emailController;
  String passwordController;

  LogIn(this.emailController, this.passwordController);

  PostData() async {
    try {
      var formData = {
        'username': emailController.toString(),
        'password': passwordController.toString(),
      };

      var res = await Dio()
          .post('http://snapped.kiska.co.in/user/login',data: formData)
          .then((response) {

        response.statusCode == 200
            ? print("successful ${response.data}")
            : print("fail");

        print(" userResponce :  $response ");
        return response;
      });
      return res;
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

class SignUp {
  String userNameControllerr;
  String emailIdController;
  String passwordController;

  SignUp(this.userNameControllerr,this.emailIdController, this.passwordController);

  PostData() async {
    try {
      var formData = {
        'username': userNameControllerr.toString(),
        'email': emailIdController.toString(),
        'password': passwordController.toString(),
      };

      var res = await Dio()
          .post('http://snapped.kiska.co.in/user/register',data: formData)
          .then((response) {

        response.statusCode == 200
            ? print("successful ${response.data}")
            : print("fail");

        print(" USER RESPONCE ${response} ");
        return response;
      });
      return res;
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