import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:snapped/utils/color.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';

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

  getPick() async {
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
          "Events Pictures",
          maxLines: 2,
          style: boldTextStyle(size: 22, color: primaryColorDark),
        ),
      ),
      body: eventPickData != null
          ? SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: eventPickData.length,
                    shrinkWrap: true,
                    staggeredTileBuilder: (int index) =>
                        StaggeredTile.count(2, index.isEven ? 3 : 2),
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    itemBuilder: (BuildContext context, int index) =>
                        Stack(children: [
                      Container(
                        height: 270,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Image.network(eventPickData[index]['url'],
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                          bottom: 5,
                          // right: 0,
                          left: 115,
                          child: SizedBox(
                              height: 30,
                              child: FloatingActionButton(
                                  onPressed: () {
                                    Share.share(
                                        "Snapped Event Pick \n ${eventPickData[index]['url']}");
                                  },
                                  backgroundColor: Colors.black45,
                                  elevation: 0,
                                  child: const Icon(
                                    Icons.share_rounded,
                                    size: 15,
                                    color: Colors.white,
                                  )))),
                    ]),
                  ),
                ),
              ]),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
