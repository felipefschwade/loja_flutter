import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_flutter/model/cart_model.dart';

class ShipCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        leading: Icon(Icons.location_city),
        title: Text(
          "Calcular frete",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.grey[700]
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu CEP"
              ),
              initialValue: "",
              onFieldSubmitted: (text) {
                
              }
            ),
          )
        ],
      ),
    );
  }
}