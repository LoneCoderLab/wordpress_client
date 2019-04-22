import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    this.getPosts();
  }

  // Base URL of WordPress API
  final String apiUrl = "http://test.zendo.cz/wp-json/wp/v2/";
  // final String apiUrl = "https://tsnovak.cz/wp-json/wp/v2/";
  // final String apiUrl = "https://virtuooza.com/wp-json/wp/v2/";

  // Empty list of posts
  List posts;

  // Function to fetch list of posts
  Future<String> getPosts() async {
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});

    // Fill posts list with results and update stats
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TEST WP'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: posts[index]["featured_media"] == 0
                      ? ''
                      : posts[index]["_embedded"]["wp:featuredmedia"]
                        [0]["source_url"]
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(posts[index]["title"]["rendered"]),
                        ),
                        subtitle: Text(
                          posts[index]["excerpt"]["rendered"]
                              .replaceAll(RegExp(r'<[^>]*>'), ''),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
