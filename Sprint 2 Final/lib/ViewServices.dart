import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:elastic_client/console_http_transport.dart';
import 'package:elastic_client/elastic_client.dart' as elastic;
import 'package:http/http.dart' as http;

final firestoreInstance = FirebaseFirestore.instance;



class ViewService extends StatelessWidget{
  final String email;
  final String salonname;
  String Id;
  ViewService(this.email, this.salonname);

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController desc = TextEditingController();
  bool available=true;


  @override
  Widget build(BuildContext context){
    // ignore: missing_required_param
    return Scaffold(
        appBar: AppBar(title:Text(('Services List  - ' + salonname)),
          backgroundColor: Colors.deepPurple[700],
        ),
      body:new StreamBuilder<QuerySnapshot>(
          stream: firestoreInstance.collection("Salon").doc(salonname).collection("Services").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text("There is are no services");
            return new ListView(children: getServiceItems(snapshot));
          })
    );


  }
  getServiceItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => new ListTile(title: new Text(doc.id), subtitle: new Text(doc.data()["description"].toString())))
        .toList();
  }


}