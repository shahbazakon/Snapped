import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:snapped/utils/color.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
            "Events Pictures",
            maxLines: 2,
            style: boldTextStyle(size: 22, color: primaryColorDark),
          ),
        ),

        // EDIT PROFILE BODY
        body: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Edit Your\nProfile Details',
                    style: boldTextStyle(size: 30)),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Expanded(
                  child: AppTextField(
                    textStyle: primaryTextStyle(
                        weight: FontWeight.bold, size: 18, color: Colors.grey),
                    textFieldType: TextFieldType.OTHER,
                    cursorColor: primaryColorDark,
                    // controller: religionController
                    //   ..text = profileDetailsData[0]["religion"],
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: primaryColorDark),
                      hintStyle: TextStyle(color: Colors.black12),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColorDark, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: grey, width: 0.5)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
