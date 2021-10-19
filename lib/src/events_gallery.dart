import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:snapped/src/edit_profile.dart';
import 'package:snapped/src/no_item_found.dart';
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

  var eventUrl = "http://snapped.kiska.co.in/api/v1/getevents/";
  var GETuserdetails = "http://snapped.kiska.co.in/api/v1/getuserdetails/";

  var eventData;
  var userDetails;

  @override
  void initState() {
    super.initState();
    getData();
    print("USER ID: $userID");
  }

  Future<void> getData() async {
    // await Future.delayed(const Duration(seconds: 2));
    print("USERID: $userID");
    // GET EVENT
    var EventRse = await Dio().get(eventUrl,
        options: Options(headers: {
          "user": userID,
        }));
    eventData = EventRse.data;
    // GET USER INFO
    var userdetailsRes = await Dio().get("$GETuserdetails$userID");
    userDetails = userdetailsRes.data;
    setState(() {});
    print(eventData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        elevation: 10.0,
        child: userDetails == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(children: [
                SizedBox(
                  height: 200,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(color: primaryColorDark),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: userDetails[0]['img'] == null
                              ? const AssetImage('assets/user.png')
                              : NetworkImage(userDetails[0]['img'])
                                  as ImageProvider,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      userDetails[0]['username'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 25.0),
                                    ),
                                    const SizedBox(height: 10.0),
                                    SizedBox(
                                      width: 220,
                                      child: Text(
                                        userDetails[0]['email'],
                                        style: const TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ]),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfile(userID: userID)));
                                },
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  color: primaryColorLite,
                                ),
                                alignment: Alignment.bottomRight,
                              )
                            ]),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 3.0),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Close Drawer',
                      style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Here you can give your route to navigate
                    Navigator.of(context).pop();
                  },
                ),
              ]),
      ),
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
            eventData == null
                ? const Center(child: CircularProgressIndicator())
                : SnappedAppBar("Event Gallery", userDetails[0]['img']),
            Expanded(
                child: eventData == null
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: getData,
                        strokeWidth: 2.5,
                        child: eventData.length == 0
                            ? const NoItemFound(
                                ErrorMsg: "You Currently Have No Event",
                                ErrorSubMag: "Wait for the Host to Share")
                            : ListView.builder(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: SizedBox(
                                              height: 150,
                                              width: 320,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                    eventData[index]['url'],
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
                                                  child: Text(
                                                          eventData[index]
                                                              ['name'],
                                                          style: boldTextStyle(
                                                              size: 18))
                                                      .expand(),
                                                ),
                                                Text(
                                                    'Host: ${eventData[index]['host']}',
                                                    style: const TextStyle(
                                                        fontSize: 14)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            child: Row(children: [
                                              Text(
                                                eventData[index]['date']
                                                    .toString()
                                                    .substring(0, 10),
                                                style: secondaryTextStyle(
                                                    size: 16),
                                              ).expand(),
                                            ]),
                                          )
                                        ],
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            elevation: 4,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                              ),
                                            ),
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
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0)),
                                            ),
                                            child: const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(18.0),
                                                child: Text(
                                                  "View Event Pictures",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            var Id = eventData[index]['ID'];
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PickGallery(Id: Id)));
                                          })
                                    ]),
                                  ]),
                                ),
                              ),
                      ))
          ]),
        ]),
      ),
    );
  }
}
