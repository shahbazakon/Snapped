import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:snapped/utils/color.dart';

class FullPreview extends StatefulWidget {
  final pickURL;

  const FullPreview({Key? key, @required this.pickURL}) : super(key: key);

  @override
  _FullPreviewState createState() => _FullPreviewState(pickURL);
}

class _FullPreviewState extends State<FullPreview> {
  final pickURL;

  _FullPreviewState(this.pickURL);

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
          },
        ),
        title: Text(
          "Events Pictures",
          maxLines: 2,
          style: boldTextStyle(size: 22, color: primaryColorDark),
        ),
      ),
      body: Center(
        child: Hero(
            tag: "pickTag", child: Image.network(pickURL, fit: BoxFit.cover)),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              String path = pickURL;
              GallerySaver.saveImage(path).then((success) {
                Fluttertoast.showToast(
                    msg: "Image is saved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1);
                setState(() {});
              });
            },
            backgroundColor: primaryColorDark,
            elevation: 0,
            child: const Icon(
              Icons.download_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              Share.share("Snapped Event Pick \n $pickURL");
            },
            backgroundColor: primaryColorLite,
            elevation: 0,
            child: const Icon(
              Icons.share_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
