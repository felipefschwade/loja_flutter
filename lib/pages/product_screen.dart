import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_flutter/data/cart_product.dart';
import 'package:loja_flutter/data/product_data.dart';
import 'package:loja_flutter/model/cart_model.dart';
import 'package:loja_flutter/model/user_model.dart';
import 'package:loja_flutter/pages/login_screen.dart';

class ProductScreen extends StatefulWidget {

  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductData product;
  String size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing:  15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                   style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),
                ),
                SizedBox(height: 16.0),
                Text("Tamanho", style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                )),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5
                    ),
                    children: product.sizes.map((m) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            size = m;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            border: Border.all(
                              color: size == m ? primaryColor : Colors.grey
                            ),
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(m),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: size == null ? null : () {
                      if (UserModel.of(context).isLoggedIn()) {

                        CartProduct cartProduct = CartProduct();
                        cartProduct.size = size;
                        cartProduct.quantity = 1;
                        cartProduct.pid = product.id;

                        CartModel.of(context).addCartItem(cartProduct);
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen())
                        );
                      }
                    },
                    child: Text(
                      UserModel.of(context).isLoggedIn() ? "Adicionar ao carrinho" : "Entre para comprar",
                      style: TextStyle(fontSize: 18.0, color: Colors.white)),
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 16.0),
                Text("Descrição", style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                )),
                Text(product.description, style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}