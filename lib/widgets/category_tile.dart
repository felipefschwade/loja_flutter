import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_flutter/pages/category_screen.dart';

class CategoryTile extends StatelessWidget {

  CategoryTile(this.snapshot);
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => CategoryScreen(snapshot))
        );
      },
    );
  }
}