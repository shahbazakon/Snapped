import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  PickedFile? _profilePick;
  final ImagePicker _picker = ImagePicker();

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
                      // SnappedLogo(),
                      ProfilePicture(),
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
                      /*profileEditMsg(),*/
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

  Widget ProfilePicture() {
    return Center(
      child: Stack(children: [
        CircleAvatar(
          radius: 60.0,
          backgroundImage: _profilePick == null
              ? AssetImage('assets/user.png')
              : FileImage(File(_profilePick!.path)) as ImageProvider,
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: SizedBox(
            height: 30,
            width: 30,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context, builder: ((builder) => bottomSheet()));
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

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Choose Profile photo",
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              FlatButton.icon(
                  onPressed: () async {
                    final pickedfile =
                        await _picker.getImage(source: ImageSource.camera);
                    setState(() {
                      _profilePick = pickedfile;
                    });
                  },
                  icon: const Icon(Icons.camera_sharp),
                  label: const Text("Camara")),
              FlatButton.icon(
                  onPressed: () async {
                    final pickedfile =
                        await _picker.getImage(source: ImageSource.gallery);
                    setState(() {
                      _profilePick = pickedfile;
                    });
                  },
                  icon: const Icon(Icons.image_rounded),
                  label: const Text("Gallery"))
            ],
          )
        ],
      ),
    );
  }

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
