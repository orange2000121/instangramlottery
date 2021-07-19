import 'package:flutter/material.dart';

class ContentPage extends StatelessWidget {
  final String url, name, content;
  ContentPage(this.url, this.content, this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              // width: _w * 0.1,
              // height: _w * 0.1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Text('name:'),
            Container(
              // alignment: Alignment.topLeft,
              // width: _w * 0.45,
              // height: _w * 0.09,
              child: Text(
                name,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('content:'),
            Container(
              // width: _w * 0.45,
              // height: _w * 0.09,
              child: Text(
                content,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
