import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:snapped/utils/color.dart';

Widget snappedTitle() {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
        text: 'SN',
        style: GoogleFonts.portLligatSans(
          // textStyle: Theme.of(context).textTheme.display1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: primaryColorLite,
        ),
        children: const [
          TextSpan(
            text: 'APP',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          TextSpan(
            text: 'ED',
            style: TextStyle(color: primaryColorLite, fontSize: 30),
          ),
        ]),
  );
}

const applicationMaxWidth = 500.0;

Widget? Function(BuildContext, String) placeholderWidgetFn() =>
    (_, s) => placeholderWidget();

Widget placeholderWidget() => Image.asset('assets/grey.jpg', fit: BoxFit.cover);

BoxConstraints dynamicBoxConstraints({double? maxWidth}) {
  return BoxConstraints(maxWidth: maxWidth ?? applicationMaxWidth);
}

double dynamicWidth(BuildContext context) {
  if (isMobile) {
    return context.width();
  } else {
    return applicationMaxWidth;
  }
}

class snappedAppBar extends StatefulWidget {
  var titleName;

  snappedAppBar(var this.titleName);

  @override
  State<StatefulWidget> createState() {
    return snappedAppBarState();
  }
}

class snappedAppBarState extends State<snappedAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                // IconButton(
                //   icon: Icon(Icons.arrow_back),
                //   color: Colors.white,
                //   onPressed: () {
                //     finish(context);
                //   },
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Center(
                    child: Text(
                      widget.titleName,
                      maxLines: 2,
                      style: boldTextStyle(size: 22, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, top: 8),
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/user.png"),
                radius: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class RefreshWidget extends StatefulWidget {
//   final Widget child;
//   final Future Function() onRefresh;
//
//   const RefreshWidget({Key? key, required this.onRefresh, required this.child})
//       : super(key: key);
//
//   @override
//   _RefreshWidgetState createState() => _RefreshWidgetState();
// }
//
// class _RefreshWidgetState extends State<RefreshWidget> {
//   @override
//   Widget build(BuildContext context) => buildAndroidList();
//
//   Widget buildAndroidList() => RefreshIndicator(
//         onRefresh: widget.onRefresh,
//         child: widget.child,
//       );
// }
