import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: datas(),
  ));
}

class datas extends StatefulWidget {
  const datas({super.key});

  @override
  State<datas> createState() => _datasState();
}

class _datasState extends State<datas> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_map();

  }

  var data;
  int count = 0;

  get_map() async {
    // http.Response res = await http.get(Uri.parse(api));

    var response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=40397731-6acd8b551fe4adf9fee5e138d&image_type=photo&pretty=true&per_page=30&q=${search_image.text}'));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    }
    count = 0;
    for (int i = 0;  data['hits'][i] != null; i++) {
      count++;
      // print(' i := ${i}');
    }
    // print("data :=");
  }


  ScrollController scrollController = ScrollController();

  // scrool_fun(){
  //   print("${scrollController}");
  //   scrollController.addListener(() {
  //     if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
  //       // Perform your task
  //       print(" end data ");
  //     }
  //   });
  // }
  TextEditingController search_image = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: search_image,
                onChanged: (value) async {
                  print(value);
                  var res = await http.get(Uri.parse(
                      'https://pixabay.com/api/?key=40397731-6acd8b551fe4adf9fee5e138d&image_type=photo&pretty=true&per_page=30&q=${value}'));
                  data = jsonDecode(res.body);
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "search images",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red))),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              child: FutureBuilder(
                future: get_map(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {

                    print(count);
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: count,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        // scrool_fun();
                        return Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.height / 3,
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "${data['hits'][index]['largeImageURL']}"))),
                          // child: Text("${data['hits'][index]['pageURL']}"),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xcdd09494),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "❤️${data['hits'][index]['likes']}",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w800)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
