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



class ViewServiceUpdate extends StatelessWidget{
  final String email;
  final String salonname;
  String Id;
  ViewServiceUpdate(this.email, this.salonname);




  @override
  Widget build(BuildContext context){
    // ignore: missing_required_param
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.white.withOpacity(0.0),title:Text(("Choose a service to update")),),

        body: Stack(
            children: <Widget>[
        new Container(
        decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/4-100.jpg"), fit: BoxFit.fill)),
    )
    ,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
    SizedBox(width: 400, height: 100,),
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


   ]) );


  }
  getServiceItems(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    return snapshot.data.docs
        .map((doc) => new ListTile(title: new Text(doc.id), onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (_)=>UpdateService(email, salonname, doc.id)));
    }, subtitle: new Text(doc.data()["description"].toString()+" Price: "+doc.data()["price"].toString())))
        .toList();
  }


}