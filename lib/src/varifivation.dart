import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapped/utils/color.dart';
import 'API Request/post.dart';
import 'Widget/bezier_container.dart';
import 'Widget/widgets.dart';
import 'login.dart';

class Verification extends StatefulWidget {
  final userNameController,passwordController,emailIdController;

  const Verification({Key? key,this.userNameController,this.passwordController ,this.emailIdController}) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState(userNameController,passwordController,emailIdController);
}

// ======================================================================================================================================//
// ----------------------------------------------------------- initialization ---------------------------------------------------//
// ======================================================================================================================================//

class _VerificationState extends State<Verification> {
  final userNameController,passwordController,emailIdController;
  _VerificationState(this.userNameController,this.passwordController ,this.emailIdController);


  bool _OTPsend = false;
  bool _OTPerror = false;
  bool ErrorVisible = false;
  bool allreadyExciestVisible = false;
  bool accountcreated = false;
  bool successVisible = false;
  bool OTPverifyed = false;
  bool WorngOTP = false;
  TextEditingController OTPController = TextEditingController();

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
    bool result = await emailAuth.sendOtp(
        recipientMail: emailIdController.text);
    print("SendOTP result : $result");
    if (result) {
      setState(() {
        print("OTP is sent");
        _OTPsend = true;
        _OTPerror = false;
        ErrorVisible = false;
        allreadyExciestVisible = false;
        accountcreated = false;
        successVisible = false;
        OTPverifyed = false;
        WorngOTP = false;
      });
    }
  }

  verifyOTP() {
    bool EmailRes = emailAuth.validateOtp(
        recipientMail: emailIdController.text, userOtp: OTPController.text);
    print("Verify EmailRes: $EmailRes");
    return EmailRes;
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
                    Image.asset(
                      'assets/email_verification.png',
                      height: 250
                    ),
                    const Text(
                      "Verify Your Email",
                      style: TextStyle(
                        color: Colors.grey
                      ),
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
                    _OTPField(OTPController),
                    const SizedBox(height: 5),
              NotificationMsg("Email Verified , Press Next", successVisible,
                  Colors.green),
                    NotificationMsg("OTP Send Successfully", _OTPsend, Colors.green),
                    NotificationMsg("Wrong OTP , Try Again", _OTPerror, Colors.red),
                    SizedBox(height: 10),
                    snappedButton(),
                    TextBtn(),
                    SizedBox(height: height * .03),
              NotificationMsg("User Already Exciest", allreadyExciestVisible,
                  Colors.red),
              NotificationMsg("Please Verify your Email", WorngOTP, Colors.red),
              NotificationMsg("Error Occure", ErrorVisible, Colors.red),
              NotificationMsg("Account is successfully Created",accountcreated, Colors.green),
                    FloatingActionButton(
                      onPressed: () async {
                        var userRes = await SignUp(userNameController.text,
                            emailIdController.text, passwordController.text)
                            .PostData();

                        if(OTPverifyed == true){
                          if (userRes.data['code'] == '1') {
                            setState(() {
                              accountcreated = true;
                              _OTPerror = false;
                              successVisible = false;
                              _OTPsend = false;
                              ErrorVisible = false;
                              allreadyExciestVisible = false;
                              OTPverifyed = false;
                              WorngOTP = false;
                            });
                            await Future.delayed(const Duration(microseconds: 1500));
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginPage(title: '')));
                          }
                          else if (userRes.data['code'] == '5') {
                            print('The user is already Exist');
                            setState(() {
                              allreadyExciestVisible = true;
                              successVisible = false;
                              _OTPerror = false;
                              ErrorVisible = false;
                              _OTPsend = false;
                              OTPverifyed = false;
                              WorngOTP = false;
                            });
                          }
                          if (userRes.data['code'] == '-1') {
                            print("Error Occurs");
                            setState(() {
                              ErrorVisible = true;
                              _OTPerror = false;
                              successVisible = false;
                              _OTPsend = false;
                              allreadyExciestVisible = false;
                              OTPverifyed = false;
                              WorngOTP = false;
                            });
                        }                        }
                        else{
                          setState(() {
                            WorngOTP = true;
                          });
                        }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => LoginPage(
                        //               title: '',
                        //             )));
                      },
                      child: Icon(Icons.arrow_forward),
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

  Widget _OTPField(TextEditingController OTPController) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
      var EmailRes = await verifyOTP();
      if(EmailRes) {
        setState(() {
          successVisible = true;
          OTPverifyed = true;
          _OTPsend = false;
          _OTPerror = false;
          ErrorVisible = false;
          allreadyExciestVisible = false;
          accountcreated = false;
        });
      }
      else{
        _OTPerror = true;
        successVisible = false;
        _OTPsend = false;
        ErrorVisible = false;
        allreadyExciestVisible = false;
        accountcreated = false;
        print("try again");
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

  TextButton TextBtn() {
    return  TextButton(
      onPressed: () async => await sendOTP(),
      child: const Text(
        "Resend OTP",
        style: TextStyle(
            color: primaryColorLite, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Visibility NotificationMsg(String Msg, bool visublitycontrlar, Color MsgColor) {
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
