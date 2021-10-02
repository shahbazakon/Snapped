import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapped/utils/color.dart';


class NoItemFound extends StatefulWidget {
  final  String ErrorMsg,ErrorSubMag;
  const NoItemFound( {Key? key, required this.ErrorMsg, required this.ErrorSubMag} ) : super(key: key);


  @override
  NoItemFoundState createState() => NoItemFoundState(ErrorMsg,ErrorSubMag);
}


class NoItemFoundState extends State<NoItemFound> {
  final String ErrorMsg;
  final String ErrorSubMag;
  NoItemFoundState(this.ErrorMsg,this.ErrorSubMag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh_rounded),
          splashColor: primaryColorLite,
          backgroundColor: primaryColorDark,
          onPressed: (){
            Navigator.pushNamed(context,'/event');
          },
        ),
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
                    Text(ErrorMsg, style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold
                    )),
                    Container(height: 5),
                    Text(ErrorSubMag, textAlign: TextAlign.center, style: const TextStyle(
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



