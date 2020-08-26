import 'package:flutter/material.dart';
import 'package:loja_flutter/pages/products_tab.dart';
import 'package:loja_flutter/widgets/custom_drawer.dart';

import 'home_tab.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: HomeTab(),
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Produtos"),
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
        ),
        Container(color: Colors.blue),
        Container(color: Colors.white),
      ],
    );
  }
}