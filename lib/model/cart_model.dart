import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_flutter/data/cart_product.dart';
import 'package:loja_flutter/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  
  List<CartProduct> products = [];

  bool isLoading = false;

  CartModel(this.user) {
    if (this.user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  static CartModel of (BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct item) {
    products.add(item);

    Firestore.instance.collection("users")
      .document(user.firebaseUser.uid)
      .collection("cart").add(item.toMap()).then((doc) => item.cid = doc.documentID);
  
    notifyListeners();
  }

  void removeCartItem(CartProduct item) {
    Firestore.instance.collection("users")
      .document(user.firebaseUser.uid)
      .collection("cart").document(item.cid).delete();
    products.remove(item);
    notifyListeners();
  }

  void decProdcut(CartProduct cartProduct) {
    cartProduct.quantity--;
    Firestore.instance.collection("users")
      .document(user.firebaseUser.uid)
      .collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProdcut(CartProduct cartProduct) {
    cartProduct.quantity++;
    Firestore.instance.collection("users")
      .document(user.firebaseUser.uid)
      .collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance.collection("users")
      .document(user.firebaseUser.uid)
      .collection("cart").getDocuments();
    products = query.documents.map((d) => CartProduct.fromDocument(d)).toList();
    notifyListeners();
  }

}