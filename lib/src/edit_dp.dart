import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:snapped/src/edit_profile.dart';
import 'package:snapped/utils/color.dart';

import 'API Request/put.dart';

class EditDP extends StatefulWidget {
  final pickURL, userID, username, email;

  const EditDP(
      {Key? key,
      @required this.userID,
      @required this.username,
      @required this.email,
      @required this.pickURL})
      : super(key: key);

  @override
  _EditDPState createState() => _EditDPState(userID, username, email, pickURL);
}

class _EditDPState extends State<EditDP> {
  final userID, email, username, pickURL;

  _EditDPState(this.userID, this.username, this.email, this.pickURL);

  TextEditingController oldPasswordController = TextEditingController();

  PickedFile? _profilePick;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: primaryColorDark,
            onPressed: () {
              finish(context);
            }),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "Edit Picture",
            maxLines: 2,
            style: boldTextStyle(size: 22, color: primaryColorDark),
          ),
          Row(children: [
            IconButton(
              onPressed: () {
                Share.share("Profile Pick on Snapped : \n $pickURL");
              },
              icon: const Icon(
                Icons.share_rounded,
                color: primaryColorLite,
                size: 20,
              ),
            ),
            const SizedBox(width: 20),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context, builder: ((builder) => bottomSheet()));
                },
                icon: const Icon(Icons.edit_outlined,
                    color: primaryColorDark, size: 25))
          ])
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Password',
                    style: TextStyle(color: primaryColorDark)),
                content: TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Enter Password",
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => const AlertDialog(
                            title: SizedBox(
                                height: 160,
                                child: Center(
                                    child: CircularProgressIndicator()))),
                      );
                      var pickRes = await editProfilePick(_profilePick,
                              username, email, oldPasswordController.text)
                          .editDetails(userID);
                      if (pickRes == '1') {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile(userID: userID)));
                      }
                      if (pickRes == '-5') {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              "Warning",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            content: const Text("Incorrect Password"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text("Ok"),
                              ),
                            ],
                          ),
                        );
                      }
                      if (pickRes != '1' && pickRes != '-5') {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              "Error",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            content: const Text("Try Again Later"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text("Ok"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: primaryColorDark,
        elevation: 0,
        child: const Icon(
          Icons.check_rounded,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: profilePicture(),
      ),
    );
  }

  Widget profilePicture() {
    return Hero(
      tag: "ProfilePickTag",
      child: Center(
          child: _profilePick != null
              ? Image.file(File(_profilePick!.path))
              : pickURL != ''
                  ? Image.network(pickURL)
                  : Image.asset("assets/user.png")),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      child: Column(children: [
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
      ]),
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
