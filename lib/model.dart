import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetData {
  static List<Users> userdata = [];

  static refreshdata(State s) async {
    List<Users> userdata1 = [];

    userdata1.clear();

    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('Users').get();

    snap.docs.forEach((element) {
      // print(element.get('username'));
      userdata1.add(Users(
        element.get('username'),
        element.get('password'),
      ));
    });

    s.setState(() {
      userdata.clear();
      userdata.addAll(userdata1);
    });
  }
}

class Users {
  var username = '';
  var password = '';

  Users(@required userid, @required password);
}
