import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _post = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    final String api =
        "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=48e28d74e52e4f0eba9b6813060e2363";
    try {
      final response = await http.get(Uri.parse(api));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _post = data['articles'];
        });
        print(_post);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Belajar Tentang Restful Api'),
      ),
      body: ListView.builder(
        itemCount: _post.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              color: Colors.grey[200],
              height: 100,
              width: 100,
              child: _post[index]['urlToImage'] != null
                  ? Image.network(
                      _post[index]['urlToImage'],
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Center(),
            ),
            title: Text(
              '${_post[index]['title']}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${_post[index]['description']}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Detail(
                      Url: _post[index]['url'],
                      title: _post[index]['title'],
                      content: _post[index]['content'],
                      pubLishedAt: _post[index]['publisheAt'],
                      author: _post[index]['author'],
                      urlToImage: _post[index]['urlToImage']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
