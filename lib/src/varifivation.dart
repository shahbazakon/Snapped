import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapped/utils/color.dart';

import 'API Request/post.dart';
import 'Widget/bezier_container.dart';
import 'login.dart';

class Verification extends StatefulWidget {
  final userNameController, passwordController, emailIdController;

  const Verification(
      {Key? key,
      this.userNameController,
      this.passwordController,
      this.emailIdController})
      : super(key: key);

  @override
  _VerificationState createState() => _VerificationState(
      userNameController, passwordController, emailIdController);
}

// ======================================================================================================================================//
// ----------------------------------------------------------- initialization ---------------------------------------------------//
// ======================================================================================================================================//

class _VerificationState extends State<Verification> {
  final userNameController, passwordController, emailIdController;

  _VerificationState(
      this.userNameController, this.passwordController, this.emailIdController);

  bool _otpSend = false;
  bool _otpError = false;
  bool errorVisible = false;
  bool allreadyExciestVisible = false;
  bool accountcreated = false;
  bool successVisible = false;
  bool otpVerifyed = false;
  bool worngOTP = false;
  TextEditingController otpController = TextEditingController();

  //--------------------------Email Authentication Method-----------------------//
  @override
  void initState() {
    super.initState();
    // Initialize the package
    emailAuth = EmailAuth(
      sessionName: "Snapped Email Authentication",
    );

    // emailAuth.config(remoteServerConfiguration);
  }

  late EmailAuth emailAuth;

  sendOTP() async {
    bool result =
        await emailAuth.sendOtp(recipientMail: emailIdController.text);
    if (result) {
      setState(() {
        _otpSend = true;
        _otpError = false;
        errorVisible = false;
        allreadyExciestVisible = false;
        accountcreated = false;
        successVisible = false;
        otpVerifyed = false;
        worngOTP = false;
      });
    }
  }

  verifyOTP() {
    bool emailRes = emailAuth.validateOtp(
        recipientMail: emailIdController.text, userOtp: otpController.text);
    return emailRes;
  }

  // ======================================================================================================================================//
  // ----------------------------------------------------------- page Architecture---------------------------------------------------//
  // ======================================================================================================================================//

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Stack(children: [
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: const BezierContainer()),
            _backButton(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .15),
                    Image.asset('assets/email_verification.png', height: 250),
                    const Text(
                      "Verify Your Email",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Container(height: 10),
                    SizedBox(
                      width: 220,
                      child: Text(
                        emailIdController.text,
                        style: const TextStyle(
                            color: primaryColorDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _otpField(otpController),
                    const SizedBox(height: 5),
                    notificationMsg("Email Verified , Press Next",
                        successVisible, Colors.green),
                    notificationMsg(
                        "OTP Send Successfully", _otpSend, Colors.green),
                    notificationMsg(
                        "Wrong OTP , Try Again", _otpError, Colors.red),
                    const SizedBox(height: 10),
                    snappedButton(),
                    textBtn(),
                    SizedBox(height: height * .03),
                    notificationMsg("User Already Exciest",
                        allreadyExciestVisible, Colors.red),
                    notificationMsg(
                        "Please Verify your Email", worngOTP, Colors.red),
                    notificationMsg("Error Occure", errorVisible, Colors.red),
                    notificationMsg("Account is successfully Created",
                        accountcreated, Colors.green),
                    FloatingActionButton(
                      onPressed: () async {
                        var userRes = await SignUp(userNameController.text,
                                emailIdController.text, passwordController.text)
                            .PostData();

                        if (otpVerifyed == true) {
                          if (userRes.data['code'] == '1') {
                            setState(() {
                              accountcreated = true;
                              _otpError = false;
                              successVisible = false;
                              _otpSend = false;
                              errorVisible = false;
                              allreadyExciestVisible = false;
                              otpVerifyed = false;
                              worngOTP = false;
                            });
                            await Future.delayed(
                                const Duration(microseconds: 1500));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginPage(title: '')));
                          } else if (userRes.data['code'] == '5') {
                            setState(() {
                              allreadyExciestVisible = true;
                              successVisible = false;
                              _otpError = false;
                              errorVisible = false;
                              _otpSend = false;
                              otpVerifyed = false;
                              worngOTP = false;
                            });
                          }
                          if (userRes.data['code'] == '-1') {
                            setState(() {
                              errorVisible = true;
                              _otpError = false;
                              successVisible = false;
                              _otpSend = false;
                              allreadyExciestVisible = false;
                              otpVerifyed = false;
                              worngOTP = false;
                            });
                          }
                        } else {
                          setState(() {
                            worngOTP = true;
                          });
                        }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => LoginPage(
                        //               title: '',
                        //             )));
                      },
                      child: const Icon(Icons.arrow_forward),
                      elevation: 2,
                    )
                  ]),
            ),
            // Positioned(top: 40, left: 0, child: _backButton()),
          ]),
        ),
      ),
    );
  }

  // ======================================================================================================================================//
  // ----------------------------------------------------------- Widget Functionalities ---------------------------------------------------//
  // ======================================================================================================================================//

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
              padding: const EdgeInsets.only(left: 0, top: 50, bottom: 50),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _otpField(TextEditingController otpController) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          TextField(
              controller: otpController,
              style: const TextStyle(
                  color: primaryColorDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
              enabled: true,
              decoration: const InputDecoration(
                labelText: 'OTP',
                contentPadding: EdgeInsets.all(0),
              ))
        ],
      ),
    );
  }

  Widget snappedButton() {
    return GestureDetector(
      onTap: () async {
        var emailRes = await verifyOTP();
        if (emailRes) {
          setState(() {
            successVisible = true;
            otpVerifyed = true;
            _otpSend = false;
            _otpError = false;
            errorVisible = false;
            allreadyExciestVisible = false;
            accountcreated = false;
          });
        } else {
          _otpError = true;
          successVisible = false;
          _otpSend = false;
          errorVisible = false;
          allreadyExciestVisible = false;
          accountcreated = false;
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
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
                colors: [Color(0xFF4CAAFF), Color(0xff06468e)])),
        child: const Text(
          'Verify',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  TextButton textBtn() {
    return TextButton(
      onPressed: () async => await sendOTP(),
      child: const Text(
        "Resend OTP",
        style: TextStyle(
            color: primaryColorLite, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Visibility notificationMsg(
      String Msg, bool visublitycontrlar, Color MsgColor) {
    return Visibility(
      visible: visublitycontrlar,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          Msg,
          textAlign: TextAlign.center,
          style: TextStyle(color: MsgColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
