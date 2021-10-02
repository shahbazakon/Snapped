import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

// import 'package:gallery_saver/gallery_saver.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:snapped/utils/color.dart';

import 'no_item_found.dart';
import 'img_full_preview.dart';

class PickGallery extends StatefulWidget {
  final Id;

  const PickGallery({Key? key, @required this.Id}) : super(key: key);

  @override
  _PickGalleryState createState() => _PickGalleryState(Id);
}

class _PickGalleryState extends State<PickGallery> {
  final Id;

  _PickGalleryState(this.Id);

  var eventPickUrl = "https://snapped.kiska.co.in/api/v1/geteventpics/";
  var eventPickData;

  @override
  void initState() {
    super.initState();
    getPick();
  }

  Future<void> getPick() async {
    var pickRes = await Dio().get('$eventPickUrl$Id');
    eventPickData = pickRes.data;
    print("DATA : $eventPickData");
    print("URL : $eventPickUrl$Id");
    print("url1 : ${eventPickData[0]['url']}");
    print("url2 : ${eventPickData[1]['url']}");
    print("LENGTH : ${eventPickData.length}");

    setState(() {});
  }

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
          "Event Pictures",
          maxLines: 2,
          style: boldTextStyle(size: 22, color: primaryColorDark),
        ),
      ),
      body: eventPickData != null
          ? RefreshIndicator(
              onRefresh: getPick,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: eventPickData.length == 0
                    ? const NoItemFound(ErrorMsg:"No Picture Found", ErrorSubMag:"Wait for the Host to Share")
                    :GridView.builder(
                        itemCount: eventPickData.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 6,
                          childAspectRatio: (40.0 / 38.0),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return SingleChildScrollView(
                            child: Stack(children: [
                              GestureDetector(
                                onTap: () {
                                  var pickURL = eventPickData[index]['url'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FullPreview(pickURL: pickURL)));
                                },
                                child: SizedBox(
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    child: Hero(
                                      tag: "pickTag",
                                      child: Image.network(
                                          eventPickData[index]['url'],
                                          height: 155,
                                          width: double.infinity,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ),

                              //SHARE BUTTON
                              Positioned(
                                bottom: 3,
                                right: -10,
                                child: SizedBox(
                                  height: 27,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      Share.share(
                                          "Snapped Event Pick \n ${eventPickData[index]['url']}");
                                    },
                                    backgroundColor: Colors.black26,
                                    elevation: 0,
                                    child: const Icon(
                                      Icons.share_rounded,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              //DOWNLOAD BUTTON
                              Positioned(
                                bottom: 3,
                                right: 20,
                                child: SizedBox(
                                  height: 27,
                                  child: FloatingActionButton(
                                    onPressed: () async {
                                      String path = eventPickData[index]['url'];
                                      GallerySaver.saveImage(path)
                                          .then((success) {
                                        Fluttertoast.showToast(
                                            msg: "Image is saved",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1);
                                        setState(() {
                                          print('Image is saved');
                                        });
                                      });
                                    },
                                    backgroundColor: Colors.black26,
                                    elevation: 0,
                                    child: const Icon(
                                      Icons.download_rounded,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          );
                        }),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
