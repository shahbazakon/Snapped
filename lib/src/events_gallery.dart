import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:snapped/src/pick_gallery.dart';
import 'package:snapped/utils/color.dart';

import 'Widget/widgets.dart';

class EventGallery extends StatefulWidget {
  final userID;

  const EventGallery({Key? key, @required this.userID}) : super(key: key);

  @override
  EventGalleryState createState() => EventGalleryState(userID);
}

class EventGalleryState extends State<EventGallery> {
  final userID;

  EventGalleryState(this.userID);

  var eventUrl = "https://snapped.kiska.co.in/api/v1/getevents/";
  var eventData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await Future.delayed(const Duration(seconds: 2));
    var res = await Dio().get(eventUrl,
        options: Options(headers: {
          "user": userID,
        }));
    eventData = res.data;
    setState(() {});
    print(eventData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height) / 3.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primaryColorLite, primaryColorDark]),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0)),
            ),
          ),
          Column(children: <Widget>[
            snappedAppBar("Events Gallery"),
            Expanded(
              child: eventData != null
                  ? RefreshIndicator(
                      onRefresh: getData,
                      strokeWidth: 2.5,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: eventData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: defaultBoxShadow(),
                              color: const Color(0xD7DAE8FC)),
                          child: Stack(children: <Widget>[
                            Column(children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      height: 150,
                                      width: 320,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.asset(
                                            "assets/eventpick.jpg",
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),

                                  // SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(eventData[index]['name'],
                                                  style:
                                                      boldTextStyle(size: 18))
                                              .expand(),
                                        ),
                                        Text(
                                            'Type: ${eventData[index]['type']}',
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      children: [
                                        Text(
                                          eventData[index]['date'],
                                          style: secondaryTextStyle(size: 16),
                                        ).expand(),
                                        IconButton(
                                            onPressed: () {
                                              Share.share(
                                                  "This is ${eventData[index]['name']} and you are invited for ${eventData[index]['type']}");
                                            },
                                            icon: const Icon(
                                              Icons.share_rounded,
                                              size: 20,
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  elevation: 4,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0))),
                                  padding: const EdgeInsets.all(0.0),
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          primaryColorLite,
                                          primaryColorDark
                                        ]),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0)),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(18.0),
                                      child: Text(
                                        "View Snapps",
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  int Id = eventData[index]['ID'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PickGallery(Id: Id)));
                                },
                              )
                            ]),
                          ]),
                        ),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            )
          ]),
        ]),
      ),
    );
  }
}
