import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/navigations/Topbar.dart';

class Searchnames extends StatefulWidget {
  Searchnames({Key key}) : super(key: key);

  @override
  _SearchnamesState createState() => _SearchnamesState();
}

class _SearchnamesState extends State<Searchnames> {
  List names;
  String k;

  Future getpopularresponse() async {
    try {
      if (k == "") {
      } else {
        var response = await Dio().get(
            "http://api.themoviedb.org/3/search/movie?api_key=360a9b5e0dea438bac3f653b0e73af47&language=en-US&page=1&include_adult=false&query=" +
                k);
        var data = response.data;

        return data;
      }
    } catch (e) {
      print(e);
    }
  }

  Timer _timer;
  @override
  void initState() {
    _timer = Timer(Duration(milliseconds: 1000), () async {
      try {
        await this.getpopularresponse().then((value) => {
              if (mounted)
                {
                  setState(() {
                    names = value["results"];
                  })
                }
            });
      } catch (e) {}
    });

    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: TextField(
              onChanged: (text) {
                setState(() {
                  k = text;
                  try {
                    getpopularresponse().then((value) => {
                          if (value == null)
                            {}
                          else
                            {
                              if (mounted)
                                {
                                  setState(() {
                                    names = value["results"];
                                  })
                                }
                            }
                        });
                  } catch (e) {}
                });
              },
              style: TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  hoverColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Search'),
            ),
          ),
          leading: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: Colors.green,
          ),
        ),
        body: getname());
  }

  Widget getname() {
    if (k == null || k == "")
      return Center(
          child: Container(
              child: Text(
        "🎥   🍟    😋",
        style: TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
      )));
    if (names == null) return Center(child: CircularProgressIndicator());

    return Container(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: ListView.builder(
            itemCount: names.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Topbar(
                                  moviename: names[index]["original_title"],
                                  
                                )));
                  },
                  child: Container(
                      margin: EdgeInsets.all(4),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 120,
                                width: 100,
                                child: names[index]["poster_path"] == null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'images/loading.png')))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: FadeInImage.assetNetwork(
                                          image:
                                              "https://image.tmdb.org/t/p/w500" +
                                                  names[index]["poster_path"],
                                          placeholder: "images/loading.png",
                                          fit: BoxFit.cover,
                                        ))),
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 230,
                                      margin:
                                          EdgeInsets.only(top: 30, left: 10),
                                      child: Text(
                                        names[index]['original_title'],
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 20),
                                      )),
                                  Container(
                                      margin:
                                          EdgeInsets.only(top: 20, left: 10),
                                      child: Text(
                                        "🌟 " +
                                            names[index]['vote_average']
                                                .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 15),
                                      ))
                                ])
                          ])));
            }));
  }
}
