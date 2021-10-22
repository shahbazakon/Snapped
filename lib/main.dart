import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapped/src/events_gallery.dart';
import 'package:snapped/src/login.dart';
import 'package:snapped/src/welcome.dart';
import 'package:snapped/utils/constants.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  Constants.userid = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // home: const WelcomePage(
      //       title: 'Snapped',
      //     ),
      home: Constants.prefs?.getBool('loggedIn') == true
          ? EventGallery(
              userID: Constants.userid?.getInt('UserID'),
            )
          : const WelcomePage(
              title: 'Snapped',
            ),
      routes: {
        '/login': (context) => const LoginPage(title: ''),
        '/event': (BuildContext context) =>
            EventGallery(userID: Constants.userid?.getInt('UserID')),
      },
    );
  }
}
