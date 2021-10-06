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


  TextEditingController UsernameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

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
                ProfilePicture(),
                const SizedBox(height: 16),
                TextField(userDetails[0]['username'], "Username",
                    UsernameController),
                TextField(
                    userDetails[0]['email'], "Email", EmailController),
                newPasswordField(),
                oldPasswordField(),

                profileEditMsg("Account details is Successfully Saved",Colors.green,successVisible),
                profileEditMsg("Old Password Not Match",Colors.red,wrongPassword),
                GestureDetector(
                  onTap: () async {
                    //PUT REQUEST TO EDIT PROFILE
                    if(oldPasswordController.text.isEmpty == false){
                      print(
                          '1: ${UsernameController.text}\n 2: ${EmailController.text}\n 3: ${newPasswordController.text} \n 4: ${oldPasswordController.text} \n $profilePick ');
                      var editRes  = await editProfileDetails(
                        profilePick,
                        UsernameController.text,
                        EmailController.text,
                        newPasswordController.text,
                        oldPasswordController.text
                      ).editDetails(userID);
                      // SHOW SUCCESS MESSAGE
                      print("Edit RESPONCE  : $editRes \n ${editRes.runtimeType}");
                      if(editRes=='1'){
                        setState(() {
                          successVisible = true;
                        });
                        await Future.delayed(const Duration(seconds: 4));
                        //MODE TO EVENT PAGE
                        Navigator.pushNamed(context, '/event');
                      }
                      if(editRes=='-5'){
                        wrongPassword = true;
                          Fluttertoast.showToast(
                              msg: "Old Password Not Match",
                              textColor: Colors.red,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1);

                      }
                      if(editRes=='-1'){
                        Fluttertoast.showToast(
                            msg: "Error! Try Again",
                            textColor: Colors.red,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1);

                      }

                    }
                    else{
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

  Widget ProfilePicture() {
    return Center(
      child: Stack(children: [
        CircleAvatar(
          radius: 60.0,
          backgroundImage: profilePick == null
              ? NetworkImage(userDetails[0]['img'])
              : FileImage(File(profilePick!.path)) as ImageProvider,
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

  Padding newPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Expanded(
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
      ),
    );
  }

  Padding oldPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Expanded(
        child: AppTextField(
          textStyle: primaryTextStyle(weight: FontWeight.bold, size: 18),
          textFieldType: TextFieldType.PASSWORD,
          cursorColor: primaryColorDark,
          controller: oldPasswordController,
          decoration: InputDecoration(
            labelText: "Old password*",
            hintText: "Old Password*",
            errorText: passwordValidation ? "Please Enter Old password" : null,
            errorStyle: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold,),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColorLite, width: 1.5)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: grey, width: 0.5)),
            labelStyle: const TextStyle(color: primaryColorDark),
          ),
        ),
      ),
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
                      profilePick = pickedfile;
                    });
                  },
                  icon: const Icon(Icons.camera_sharp),
                  label: const Text("Camara")),
              FlatButton.icon(
                  onPressed: () async {
                    final pickedfile =
                    await _picker.getImage(source: ImageSource.gallery);
                    setState(() {
                      profilePick = pickedfile;
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

  Padding profileEditMsg(String Msg,Color mycolor, bool isvisible) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Visibility(
        visible: isvisible,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Msg,
            textAlign: TextAlign.center,
            style: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}