import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_flutter/data/product_data.dart';

class CartProduct {
  String cid;
  String category;
  String pid;
  int quantity;
  String size;
  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.documentID;
    category = document.data["category"];
    quantity = document.data["quantity"];
    size = document.data["size"];
    pid = document.data["pid"];
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "product": productData.toResumedMap()
    };
  }
}
