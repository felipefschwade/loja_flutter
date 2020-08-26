import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  bool isLoading = false;
  Map<String, dynamic> userData = Map();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  bool isLoggedIn() {
    print(firebaseUser);
    return firebaseUser != null;
  }

  static UserModel of (BuildContext context) => ScopedModel.of<UserModel>(context);

  @override
  void addListener(listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signUp({
    @required Map<String, dynamic> userData, 
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail
  }) {
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
      email: userData["email"], 
      password: pass
    ).then((FirebaseUser user) async {
      firebaseUser = user;
      await _saveUserData(userData);
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });

  }

  void signOut() {
    _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  void signIn({
    @required String email, 
    @required String pass, 
    @required VoidCallback onSuccess, 
    @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    _auth.signInWithEmailAndPassword(email: email, password: pass).then((user) {
      firebaseUser = user;
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
    await _loadCurrentUser();
  }

  void recoverPass(String email) {
    // _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    Firestore.instance.collection("users")
      .document(firebaseUser.uid)
      .setData(userData)
      .catchError((onError) => print(onError));
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }
    if ( firebaseUser != null) {
      if(userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
        notifyListeners();
      }
    }
  }

}