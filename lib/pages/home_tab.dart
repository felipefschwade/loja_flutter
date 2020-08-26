import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {

  Widget _buildBodyBack() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 211, 118, 130),
          Color.fromARGB(255, 253, 181, 168)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection('home').orderBy('pos').getDocuments(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  );
                } else {
                  return SliverStaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    staggeredTiles: snapshot.data.documents.map((DocumentSnapshot m) {
                      return StaggeredTile.count(m.data["x"], m.data["y"]);
                    }).toList(),
                    children: snapshot.data.documents.map((DocumentSnapshot m) {
                      return FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage, 
                        image: m.data["image"],
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  );
                }
              }
            ),
          ],
        )
      ],
    );
  }
}