import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapped/utils/color.dart';

import 'API Request/post.dart';
import 'Widget/auth.config.dart';
import 'Widget/bezier_container.dart';
import 'Widget/widgets.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool successVisible = false;
  bool ErrorVisible = false;
  bool _OTPsend = false;
  bool _OTPerror = false;
  bool allreadyExciestVisible = false;
  bool _isObscure = true;

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController OTPController = TextEditingController();



  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController myController) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              controller: myController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _OTPField(String title,TextEditingController OTPController) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: OTPController,
              style: const TextStyle(
                  color: primaryColorDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
              enabled: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                suffix: TextButton(
                    onPressed:()=> sendOtp(),
                    child: const Text(
                      "Send OTP",
                      style: TextStyle(
                          color: primaryColorDark,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
              ))
        ],
      ),
    );
  }

  Widget _passwordntryField(String title, TextEditingController MyController) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              controller: MyController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  fillColor: const Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () async {
        var userRes = await SignUp(userNameController.text,
                emailIdController.text, passwordController.text)
            .PostData();
        if (userRes.data['code'] == '-1') {
          print("Error Occurs");
          setState(() {
            ErrorVisible = true;
          });
        }
        if (userRes.data['code'] == '1') {
          setState(() {
            successVisible = true;
          });
          await Future.delayed(const Duration(seconds: 2));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginPage(title: '')));
        }
        if (userRes.data['code'] == '5') {
          print('The user is already exciest');
          setState(() {
            allreadyExciestVisible = true;
          });
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      title: '',
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [primaryColorLite, primaryColorDark])),
        child: const Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      title: 'title is here',
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: primaryColorLite,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username", userNameController),
        _passwordntryField("Password", passwordController),
        _entryField("Email id", emailIdController),
        _OTPField("OTP",OTPController),
      ],
    );
  }
  @override
  void initState() {
    super.initState();
    // Initialize the package
    emailAuth = EmailAuth(
      sessionName: "Sample session",
    );

    // emailAuth.config(remoteServerConfiguration);
  }

  late EmailAuth emailAuth;

  sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: emailIdController.text, otpLength: 4);
    if (result) {
      setState(() {
        print("OTP is sent");
        _OTPsend = true;
      });
    }
  }

  void verify() {
    bool EmailRes = emailAuth.validateOtp(
        recipientMail: emailIdController.text, userOtp: OTPController.text);
    if (EmailRes) {
      print('OTP varified');
    } else {
      print('Wrong OTP');
      _OTPerror = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: const BezierContainer(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    snappedTitle(),
                    const SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: successVisible,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Account is Successfully Created",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _OTPsend,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "OTP Send Successfully",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _OTPerror,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Wrong OTP , Try Again",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: ErrorVisible,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Error Occure",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: allreadyExciestVisible,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "User Already Exciest",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ),
      ),
    );
  }
}
