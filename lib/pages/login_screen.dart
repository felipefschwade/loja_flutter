import 'package:flutter/material.dart';
import 'package:loja_flutter/model/user_model.dart';
import 'package:loja_flutter/pages/singn_up_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState> ();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    _onSuccess() {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Usuário conectado com sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
      );
      Future.delayed(Duration(seconds: 2)).then((_) => Navigator.of(context).pop());
    }

    _onFail() {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao conectar o usuário"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => SignUpScreen())
              );
            },
            child: Text(
              "CRIAR CONTA ",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white
              ),
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (BuildContext context, Widget child, UserModel model) {
          if (model.isLoading) return Center(child: CircularProgressIndicator());
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "E-mail"
                  ),
                  validator: (String text) {
                    if (text.isEmpty || !text.contains("@")) return "E-mail inválido";
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    hintText: "Senha"
                  ),
                  obscureText: true,
                  validator: (String text) {
                    if (text.isEmpty || text.length < 6) return "Senha inválida";
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Insira seu email para recuperação"),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          )
                        );
                      } else {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Email de recuperação enviado, confira o seu email!"),
                            backgroundColor: Theme.of(context).primaryColor,
                            duration: Duration(seconds: 2),
                          )
                        );
                        model.recoverPass(_emailController.text);
                      }
                    },
                    child: Text(
                      "Esqueci minha senha", 
                      textAlign: TextAlign.right, 
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        model.signIn(
                          email: _emailController.text.trim(),
                          pass: _passController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail,
                        );
                      }
                    },
                    child: Text("Entrar",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }
}