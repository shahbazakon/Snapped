import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:snapped/utils/color.dart';

import 'API Request/put.dart';

class EditProfile extends StatefulWidget {
  final userID;

  const EditProfile({Key? key, @required this.userID}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState(userID);
}

class _EditProfileState extends State<EditProfile> {
  final userID;

  _EditProfileState(this.userID);

  bool successVisible = false;

  TextEditingController UsernameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  var GETuserdetails = "https://snapped.kiska.co.in/api/v1/getuserdetails/";
  var userDetails;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var userdetailsRes = await Dio().get("$GETuserdetails$userID");
    userDetails = userdetailsRes.data;
    setState(() {});
  }
// ======================================================= SCAFFOLD START ===========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // APP BAR
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: primaryColorDark,
            onPressed: () {
              finish(context);
            },
          ),
          title: Text(
            "Edit Profile",
            maxLines: 2,
            style: boldTextStyle(size: 22, color: primaryColorDark),
          ),
        ),

        // EDIT PROFILE BODY
        body: userDetails == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // MAIN LOGO
                      SnappedLogo(),
                      const SizedBox(height: 16),
                      // USERNAME FIELD
                      TextField(userDetails[0]['username'], "Username",
                          UsernameController),
                      // EMAIL FIELD
                      TextField(
                          userDetails[0]['email'], "Email", EmailController),
                      // SAVE DETAILS BUTTON
                      passwordField(),
                      // SAVE DETAILS BUTTON
                      profileEditMsg(),
                      GestureDetector(
                        onTap: () async {
                          //PUT REQUEST TO EDIT PROFILE
                          print(
                              '1: ${UsernameController.text}\n 2: ${EmailController.text}\n 3: ${PasswordController.text}');
                          await editProfileDetails(
                            UsernameController.text,
                            EmailController.text,
                            PasswordController.text,
                          ).editDetails(userID);
                          // SHOW SUCCESS MESSAGE
                          setState(() {
                            successVisible = true;
                          });
                          await Future.delayed(const Duration(seconds: 4));

                          //MODE TO EVENT PAGE
                          Navigator.pushNamed(context, '/event');
                        },
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 10),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
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
                                  colors: [
                                    Color(0xFF4CAAFF),
                                    Color(0xff06468e)
                                  ])),
                          child: const Text(
                            'Save Details',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }

  // =======================================================WIDGETS WORKING===========================================================================

  Padding profileEditMsg() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Visibility(
        visible: successVisible,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Account details is Successfully Saved",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Padding passwordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Expanded(
        child: AppTextField(
          textStyle: primaryTextStyle(weight: FontWeight.bold, size: 18),
          textFieldType: TextFieldType.PASSWORD,
          cursorColor: primaryColorDark,
          controller: PasswordController,
          decoration: const InputDecoration(
            labelText: "password",
            hintText: "New Password",
            labelStyle: TextStyle(color: primaryColorDark),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColorLite, width: 1.5)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grey, width: 0.5)),
          ),
        ),
      ),
    );
  }

  Padding SnappedLogo() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Image.asset(
        'assets/snappedLogo.png',
        height: 80,
      ),
    );
  }

  Padding TextField(
      String Myinitvalue, String MyLabel, TextEditingController MyController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Expanded(
        child: AppTextField(
          textStyle: primaryTextStyle(weight: FontWeight.bold, size: 18),
          textFieldType: TextFieldType.EMAIL,
          cursorColor: primaryColorDark,
          controller: MyController..text = Myinitvalue,
          decoration: InputDecoration(
            labelText: MyLabel,
            labelStyle: const TextStyle(color: primaryColorDark),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColorLite, width: 1.5)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: grey, width: 0.5)),
          ),
        ),
      ),
    );
  }
}
