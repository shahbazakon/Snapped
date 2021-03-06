import 'package:flutter/material.dart';
import 'package:snapped/src/API%20Request/post.dart';
import 'package:snapped/src/events_gallery.dart';
import 'package:snapped/src/signup.dart';
import 'package:snapped/utils/color.dart';
import 'package:snapped/utils/constants.dart';
import 'Widget/bezier_container.dart';
import 'Widget/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  bool wrongValues = false;
  bool indelidDetalis = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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

  Widget _passwordntryField(String title, TextEditingController myController) {
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

  Widget snappedButton() {
    return GestureDetector(
      onTap: () async {
        var userRes = await LogIn(emailController.text, passwordController.text)
            .PostData();
        if(emailController.text.isEmpty == false && passwordController.text.isEmpty == false) {
          if (userRes.data['code'] == '-1') {
            setState(() {
              wrongValues = true;
              indelidDetalis = false;
            });
          }
          if (userRes.data['code'] == '1') {
            Constants.prefs?.setBool('loggedIn', true);
            var userID = userRes.data['userID'];
            Constants.userid?.setInt('UserID', userID);

            EventGallery(userID: userID);
            Navigator.pushReplacementNamed(context, '/event');
          }
        }
        else{
          setState(() {
            indelidDetalis = true ;
            wrongValues = false;
          });
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
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SignUpPage(
                      title: 'Snapped',
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
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
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
        _entryField("Username", emailController),
        _passwordntryField("Password", passwordController),
      ],
    );
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
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: const BezierContainer()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    snappedTitle(),
                    const SizedBox(height: 50),
                    _emailPasswordWidget(),
                    Visibility(
                        visible: wrongValues,
                        child: const Text(
                          "Wrong Username OR Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        )),
                    Visibility(
                        visible: indelidDetalis,
                        child: const Text(
                          "Invalid Username OR Password ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        )),
                    const SizedBox(height: 20),
                    snappedButton(),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: const Text('Forgot Password ?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: height * .055),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
