import 'package:flutter/material.dart';
import 'package:loja_flutter/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }

}

class _SignUpScreenState extends State<SignUpScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState> ();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      )
    );
    Future.delayed(Duration(seconds: 2)).then((_) => Navigator.of(context).pop());
  }

  _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao criar usuário"),
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
        title: Text("Criar Conta"),
        centerTitle: true,
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nome completo"
                  ),
                  validator: (String text) {
                    if (text.isEmpty) return "Nome inválido";
                  },
                ),
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
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: "Endereço"
                  ),
                  validator: (String text) {
                    if (text.isEmpty) return "Endereço inválido";
                  },
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: () {
                      Map<String, dynamic> userData = {
                        "name": _nameController.text,
                        "email": _emailController.text,
                        "address": _addressController.text,
                      };

                      if (_formKey.currentState.validate()) {
                        model.signUp(
                          userData: userData,
                          pass: _passController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail);
                      }
                    },
                    child: Text("Criar Conta",
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