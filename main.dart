import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show get;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<ListData>> listDataJSON() async {
    final url = "http://www.finenut.in/demo/fetchData.php";
    final response = await get(url);
    if (response.statusCode == 200) {
      List listData = json.decode(response.body);
      return listData
          .map((listData) => new ListData.fromJson(listData))
          .toList();
    } else {
      throw Exception("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              alertDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder<List<ListData>>(
              future: listDataJSON(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Expanded(
                    child: new ListView.builder(
                        itemCount: snapshot.data.length,
                        padding: EdgeInsets.all(10),
                        itemBuilder: (BuildContext context, int currentIndex) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        color: Colors.grey,
                                        width: 60.0,
                                        height: 60.0,
                                        child: Center(
                                          child: Text(
                                            snapshot.data[currentIndex].id,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          snapshot.data[currentIndex].title,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () {
                                      alertDialog(
                                          id: snapshot.data[currentIndex].id,
                                          title: snapshot
                                              .data[currentIndex].title);
                                    },
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          );
                        }),
                  );
                }
              }),
        ],
      ),
    );
  }

  Future<bool> alertDialog({String id, String title}) {
    TextEditingController textEditingController =
        TextEditingController(text: title);

    void updateData() {
      var url = "http://www.finenut.in/demo/updateData.php";
      http.post(url, body: {
        "id": id,
        "title": textEditingController.text,
      });
    }

    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Column(
          children: [
            TextFormField(
              controller: textEditingController,
              onChanged: (String value) {
                setState(() {
                  title = value;
                });
              },
              onFieldSubmitted: (v) {
                updateData();
              },
              decoration: InputDecoration(labelText: 'Title'),
            ),
            Container(
              width: 300.0,
              margin: EdgeInsets.only(top: 10.0),
              child: RaisedButton(
                color: Colors.blue,
                child: Text(
                  'Update Data',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  updateData();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListData {
  final String id;
  final String title;

  ListData({
    this.id,
    this.title,
  });

  factory ListData.fromJson(Map<String, dynamic> jsonData) {
    return ListData(
      id: jsonData['id'],
      title: jsonData['title'],
    );
  }
}
