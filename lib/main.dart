import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  List newsData;
  Future<String> Data() async {
    var response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=In&apiKey=3a408c34077e4804a3a508f2b75c6484');
    setState(() {
      var result = json.decode(response.body);
      newsData = result['articles'];
    });
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        MapViewsState.finalposition = position;
      });
    }).catchError((e) {});
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  initState() {
    Data();
    _getCurrentLocation();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Swipe'),
        ),
        body: ListView.builder(
            itemCount: newsData == null ? 0 : newsData.length,
            itemBuilder: (context, index) {
              return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      icon: Icons.share,
                      caption: 'Share',
                      color: Colors.green,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("Share the news"),
                                  content: Container(
                                    height: 100,
                                    width: 100,
                                    child: Text('Whatsapp\n\nGmail'),
                                  ));
                            });
                      },
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      icon: Icons.delete,
                      color: Colors.red,
                      onTap: () {
                        setState(() {
                          newsData.removeAt(index);
                        });
                      },
                    )
                  ],
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapViews(),
                          ));
                    },
                    child: Card(
                        child: Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 35, left: 10),
                      child: Text(newsData[index]['title']),
                    )),
                  ));
            }),
      ),
    );
  }
}
