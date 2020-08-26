import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_flutter/data/product_data.dart';
import 'package:loja_flutter/widgets/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  
  CategoryScreen(this.snapshot);

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.list))
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection('products').document(snapshot.documentID).collection("items").getDocuments(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                GridView.builder(
                  padding: EdgeInsets.all(4.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 0.65
                  ),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    ProductData data = ProductData.fromDocument(snapshot.data.documents[index]);
                    data.category = this.snapshot.documentID;
                    return ProductTile(ProductTileType.grid, data);
                  },
                ),
                ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    ProductData data = ProductData.fromDocument(snapshot.data.documents[index]);
                    data.category = this.snapshot.documentID;
                    return ProductTile(ProductTileType.list, data);
                  },
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}