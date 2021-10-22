import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapped/utils/color.dart';


class NoItemFound extends StatefulWidget {
  final  String errorMsg,errorSubMag;
  const NoItemFound( {Key? key, required this.errorMsg, required this.errorSubMag} ) : super(key: key);


  @override
  NoItemFoundState createState() => NoItemFoundState(errorMsg,errorSubMag);
}


class NoItemFoundState extends State<NoItemFound> {
  final String errorMsg;
  final String errorSubMag;
  NoItemFoundState(this.errorMsg,this.errorSubMag);

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
                    Text(errorMsg, style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold
                    )),
                    Container(height: 5),
                    Text(errorSubMag, textAlign: TextAlign.center, style: const TextStyle(
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



