import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_flutter/data/cart_product.dart';
import 'package:loja_flutter/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  
  List<CartProduct> products = [];

  bool isLoading = false;
  String cupomCode = "";
  int discountPercentage = 0;

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

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    products.forEach((element) {
      if (element.productData != null) {
        price += element.quantity * element.productData.price;
      }
    });
    return price;
  }

  double getShipPrice() {
    return 9.99;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  void setCupom(String cupomCode, int discountPercentage) {
    this.discountPercentage = discountPercentage;
    this.cupomCode = cupomCode;
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

  Future<String> finishOrder() async {
    if (products.length  == 0) return null;
    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
      {
        "clientId": user.firebaseUser.uid,
        "products": products.map((CartProduct c) => c.toMap()).toList(),
        "shipPrice": shipPrice,
        "productsPrice": productsPrice,
        "discount": discount,
        "totalPrice": productsPrice - discount + shipPrice,
        "status": 1
      }
    );

    await Firestore.instance.collection("users")
      .document(user.firebaseUser.uid).collection("orders")
      .document(refOrder.documentID).setData(
        {
          "orderId": refOrder.documentID
        }
      );

    QuerySnapshot query = await Firestore.instance.collection("users")
      .document(user.firebaseUser.uid).collection("cart").getDocuments();

    for (DocumentSnapshot item in query.documents) {
      item.reference.delete();
    }

    products.clear();
    discountPercentage = 0;
    cupomCode = null;
    isLoading = false;
    notifyListeners();

    return refOrder.documentID;

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