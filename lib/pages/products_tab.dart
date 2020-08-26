import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_flutter/widgets/category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('products').getDocuments(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) { 
       if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          var dividedTiles = ListTile.divideTiles(
            tiles: snapshot.data.documents.map((DocumentSnapshot m) => CategoryTile(m)).toList(),
            color: Colors.grey[500]
          ).toList();
          return ListView(
            children: dividedTiles
          );
        }
      }
    );
  }
}