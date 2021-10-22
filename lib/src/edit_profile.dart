import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:snapped/src/edit_dp.dart';
import 'package:snapped/utils/color.dart';

import 'API Request/put.dart';
import 'events_gallery.dart';

class EditProfile extends StatefulWidget {
  final userID;

  const EditProfile({Key? key, @required this.userID}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState(userID);
}

class _EditProfileState extends State<EditProfile> {
  // ======================================================================================================================================//
  // ----------------------------------------------------------- Initialization -----------------------------------------------------------//
  // ======================================================================================================================================//

  final userID;

  _EditProfileState(this.userID);

  PickedFile? profilePick;
  final ImagePicker _picker = ImagePicker();

  bool successVisible = false;
  bool passwordValidation = false;
  bool wrongPassword = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  var getUserDetails = "http://snapped.kiska.co.in/api/v1/getuserdetails/";
  var userDetails;

  @override
  void initState() {
    super.initState();

    getData();
  }

  Future<void> getData() async {
    var userDetailsRes = await Dio().get("$getUserDetails$userID");
    userDetails = userDetailsRes.data;
    setState(() {});
  }

  // ======================================================================================================================================//
  // ----------------------------------------------------------- Page Architecture --------------------------------------------------------//
  // ======================================================================================================================================//

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
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventGallery(userID: userID)));
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
                      GestureDetector(
                        child: profilePicture(),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contest) => EditDP(
                                      userID: userID,
                                      username: usernameController.text,
                                      email: emailController.text,
                                      pickURL: userDetails[0]['img'])));
                        },
                      ),
                      const SizedBox(height: 16),
                      textField(userDetails[0]['username'], "Username",
                          usernameController),
                      textField(
                          userDetails[0]['email'], "Email", emailController),
                      newPasswordField(),
                      oldPasswordField(),
                      profileEditMsg("Account details is Successfully Saved",
                          Colors.green, successVisible),
                      profileEditMsg(
                          "Old Password Not Match", Colors.red, wrongPassword),
                      GestureDetector(
                        onTap: () async {
                          //PUT REQUEST TO EDIT PROFILE
                          if (oldPasswordController.text.isEmpty == false) {
                            var editRes = await editInfoDetails(
                                    usernameController.text,
                                    emailController.text,
                                    newPasswordController.text,
                                    oldPasswordController.text)
                                .editDetails(userID);
                            if (editRes == '1') {
                              setState(() {
                                successVisible = true;
                              });
                              await Future.delayed(const Duration(seconds: 2));
                              //MODE TO EVENT PAGE
                              Navigator.pushNamed(context, '/event');
                            }
                            if (editRes == '-5') {
                              wrongPassword = true;
                              Fluttertoast.showToast(
                                  msg: "Old Password Not Match",
                                  textColor: Colors.red,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1);
                            }
                            if (editRes == '-1') {
                              Fluttertoast.showToast(
                                  msg: "Error! Try Again",
                                  textColor: Colors.red,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1);
                            }
                          } else {
                            setState(() {
                              Fluttertoast.showToast(
                                  msg: "Old Password Not Found",
                                  textColor: Colors.red,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1);
                              passwordValidation = true;
                            });
                          }
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

  // ======================================================================================================================================//
  // ----------------------------------------------------------- Widget Functionalities ---------------------------------------------------//
  // ======================================================================================================================================//

  Widget profilePicture() {
    return Center(
      child: Stack(children: [
        Hero(
          tag: "ProfilePickTag",
          child: CircleAvatar(
            radius: 60.0,
            backgroundImage: userDetails[0]['img'] != ''
                ? NetworkImage(userDetails[0]['img'])
                : const AssetImage("assets/user.png") as ImageProvider,
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: SizedBox(
            height: 30,
            width: 30,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contest) => EditDP(
                            userID: userID,
                            username: usernameController.text,
                            email: emailController.text,
                            pickURL: userDetails[0]['img'])));
              },
              backgroundColor: Colors.blue,
              elevation: 0,
              child: const Icon(
                Icons.add_a_photo_outlined,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Padding snappedLogo() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Image.asset(
        'assets/snappedLogo.png',
        height: 80,
      ),
    );
  }

  Padding textField(
      String myInitvalue, String myLabel, TextEditingController myController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: AppTextField(
        textStyle: primaryTextStyle(weight: FontWeight.bold, size: 18),
        textFieldType: TextFieldType.EMAIL,
        cursorColor: primaryColorDark,
        controller: myController..text = myInitvalue,
        decoration: InputDecoration(
          labelText: myLabel,
          labelStyle: const TextStyle(color: primaryColorDark),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primaryColorLite, width: 1.5)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: grey, width: 0.5)),
        ),
      ),
    );
  }

  Padding newPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: AppTextField(
        textStyle: primaryTextStyle(weight: FontWeight.bold, size: 18),
        textFieldType: TextFieldType.PASSWORD,
        cursorColor: primaryColorDark,
        controller: newPasswordController,
        decoration: const InputDecoration(
          labelText: "New password",
          hintText: "New Password",
          labelStyle: TextStyle(color: primaryColorDark),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColorLite, width: 1.5)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: grey, width: 0.5)),
        ),
      ),
    );
  }

  Padding oldPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: AppTextField(
        textStyle: primaryTextStyle(weight: FontWeight.bold, size: 18),
        textFieldType: TextFieldType.PASSWORD,
        cursorColor: primaryColorDark,
        controller: oldPasswordController,
        decoration: InputDecoration(
          labelText: "Old password*",
          hintText: "Old Password*",
          errorText: passwordValidation ? "Please Enter Old password" : null,
          errorStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.5)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primaryColorLite, width: 1.5)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: grey, width: 0.5)),
          labelStyle: const TextStyle(color: primaryColorDark),
        ),
      ),
    );
  }

  Padding profileEditMsg(String msg, Color myColor, bool isVisible) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Visibility(
        visible: isVisible,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(color: myColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
