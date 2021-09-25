import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NoItemFound extends StatefulWidget {
  const NoItemFound({Key? key}) : super(key: key);

  @override
  NoItemFoundState createState() => NoItemFoundState();
}


class NoItemFoundState extends State<NoItemFound> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/bg_no_item.png', width: double.infinity),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 60),
                width: 250,
                child: Column(
                  children: <Widget>[
                    const Text("No Snapps Found", style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold
                    )),
                    Container(height: 5),
                    const Text("Weight for the Host to Shear", textAlign: TextAlign.center, style: TextStyle(
                        color: Colors.grey
                    )),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}

