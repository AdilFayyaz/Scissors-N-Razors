import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elasticcloud/UpdateService.dart';
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
import 'UpdateService.dart';

final firestoreInstance = FirebaseFirestore.instance;



class ViewServiceDelete extends StatelessWidget{
  final String email;
  final String salonname;
  String Id;
  ViewServiceDelete(this.email, this.salonname);

  void _showDialog(BuildContext context, String service) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are You Sure?"),
          content: new Text("Are you sure you want to remove "+service+"?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                CollectionReference salonRef = firestoreInstance.collection("Salon").doc(salonname).collection("Services");

                final docRef = salonRef.doc(service).delete().whenComplete(() => Navigator.pop(context));
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context){
    // ignore: missing_required_param
    return Scaffold(
        appBar: AppBar(title:Text(("Choose a service to delete")),),
        body:
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreInstance.collection("Salon").doc(salonname).collection("Services").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return new Text("There is are no services");
                    return new ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(30.0),
                        children: getServiceItems(snapshot, context));
                  }),

            ),

          ],
        )


    );


  }
  getServiceItems(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    return snapshot.data.docs
        .map((doc) => new ListTile(title: new Text(doc.id), onTap: (){
      _showDialog(context, doc.id);
    }, subtitle: new Text(doc.data()["description"].toString()+" Price: "+doc.data()["price"].toString())))
        .toList();
  }


}