import 'package:flutter/material.dart';
import 'package:loja_flutter/model/user_model.dart';
import 'package:loja_flutter/pages/login_screen.dart';
import 'package:loja_flutter/widgets/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  Widget _buildBodyBack() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 203, 236, 241),
          Colors.white
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildBodyBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text("Flutter's\nClothing", style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold)),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (BuildContext context, Widget child, UserModel model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}", style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold
                              )),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn() ? 
                                    "Entre ou cadastre-se" :
                                    "Sair", 
                                  style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                                )),
                                onTap: () {
                                  if (!model.isLoggedIn()) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (BuildContext context) => LoginScreen())
                                    );
                                  } else {
                                    model.signOut();
                                  }
                                },
                              )
                            ],
                          );
                        },
                      )
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Meus pedidos", pageController, 3),
            ],
          ),
        ],
      ),
    );
  }
}