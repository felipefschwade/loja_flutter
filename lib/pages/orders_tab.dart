

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_flutter/model/user_model.dart';
import 'package:loja_flutter/widgets/order_tile.dart';

import 'login_screen.dart';

class OrdersTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uuid = UserModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("users")
          .document(uuid).collection("orders").getDocuments(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, i) {
                  return OrderTile(snapshot.data.documents[i].documentID);
                },
              );
            }
          }
      );

    } else {
      return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.remove_shopping_cart,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Faça o login para adicionar produtos!",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16.0,
            ),
            RaisedButton(
              child: Text("Entrar", style: TextStyle(fontSize: 18.0)),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
            )
          ],
        ),
      );
    }
  }
}