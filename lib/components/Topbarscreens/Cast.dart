import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Cast extends StatefulWidget {
  final id;
  Cast({Key key, @required this.id}) : super(key: key);

  @override
  _CastState createState() => _CastState();
}

class _CastState extends State<Cast> {
  List cast;

  void getpopularresponse() async {
    var response = await Dio().get("https://api.themoviedb.org/3/movie/" +
        widget.id.toString() +
        "/credits?api_key=8b5da40bcd2b5fa4afe55c468001ad8a&language=en-US");
    var data = response.data;
    try {
      if (mounted) {
        setState(() {
          cast = data["cast"];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    this.getpopularresponse();
  }

  Widget build(BuildContext context) {
    if (cast == null) return Center(child: CircularProgressIndicator());
    return Container(
        height: 50.0,
        margin: EdgeInsets.only(top: 10, left: 20),
        width: double.infinity,
        child: ListView.builder(
            itemCount: cast.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {},
                  child: Container(
                      margin: EdgeInsets.all(10), child: gethead(cast, index)));
            }));
  }

  Widget gethead(cast, index) {
    return Container(
        child: Row(children: [
      CircleAvatar(
        radius: 32,
        backgroundImage: NetworkImage(cast[index]["profile_path"] == null
            ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR28i5jWF37DvM01csPLTUTxEvCUAiL1ho6qw&usqp=CAU"
            : "https://image.tmdb.org/t/p/w500" + cast[index]["profile_path"]),
      ),
      Expanded(
          child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 20, bottom: 10),
        child: Text(
          cast[index]["name"],
          style: TextStyle(
              fontFamily: 'fonts/Lato-Bold.ttf',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none),
        ),
      )),
    ]));
  }
}
