import 'package:cloud_firestore/cloud_firestore.dart';
import 'UpdateService.dart';
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



class DeleteDeal extends StatelessWidget{
  final String email;
  final String salonname;
  String Id;
  DeleteDeal(this.email, this.salonname);

  void _showDialog(BuildContext context, String deal) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are You Sure?"),
          content: new Text("Are you sure you want to remove "+deal+"?"),
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
                CollectionReference salonRef = firestoreInstance.collection("Salon").doc(salonname).collection("Deals");

                final docRef = salonRef.doc(deal).delete().whenComplete(() => Navigator.pop(context));
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
        appBar: AppBar(title:Text(("Choose A Deal To Delete")),),
        body:
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreInstance.collection("Salon").doc(salonname).collection("Deals").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return new Text("There is are no deals");
                    return new ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(30.0),
                        children: getDealItems(snapshot, context));
                  }),

            ),

          ],
        )


    );


  }
  String itemsList(final doc){
    List<String> items=List.from(doc.data()["items"]);
    String itemslist="";
    for (int i=0; i<items.length; i++){
      itemslist+=" "+items.elementAt(i);
    }
    return itemslist;
  }
  getDealItems(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    
    
    
    return snapshot.data.docs
        .map((doc) => new ListTile(title: new Text(doc.id), onTap: (){
      _showDialog(context, doc.id);
    }, subtitle: new Text("Price: "+doc.data()["price"].toString()+" Items:"+itemsList(doc))))
        .toList();
  }


}