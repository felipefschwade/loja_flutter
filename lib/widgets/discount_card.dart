import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_flutter/model/cart_model.dart';

class DiscountCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        leading: Icon(Icons.card_giftcard),
        title: Text(
          "Cupom de desconto",
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
                hintText: "Digite o seu cupom"
              ),
              initialValue: CartModel.of(context).cupomCode ?? "",
              onFieldSubmitted: (text) {
                Firestore.instance.collection("coupons").document(text).get().then((snap) {
                  if (snap.exists) {
                    CartModel.of(context).setCupom(text, snap.data["percent"]);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Desconto de ${snap.data["percent"]}% aplicado!"),
                        backgroundColor: Theme.of(context).primaryColor,
                      )
                    );
                  } else {
                    CartModel.of(context).setCupom("", 0);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Cupom não existente!"),
                        backgroundColor: Colors.redAccent,
                      )
                    );
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}