//import 'customerDashboard.dart';

import 'ManageSalon.dart';
import 'addSalon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
final firestoreInstance = FirebaseFirestore.instance;

class SalonOwnerDashboard extends StatelessWidget {

  final email;
  SalonOwnerDashboard(this.email);

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text(('Salon')),),
        floatingActionButton: FloatingActionButton(child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (_)=>addSalonOwner()));
          },),
        body: Center(child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('Salon Dashboard', style: TextStyle(fontSize: 30.0),),
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>addSalonOwner()));
              },
            ),
          ),

          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('getSalonOwnerDetails', style: TextStyle(fontSize: 20.0),),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>getSalonOwner(email)));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('Add Salon', style: TextStyle(fontSize: 20.0),),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>addSalon(email)));
              },
            ),
          ),

          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('Manage Salon', style: TextStyle(fontSize: 20.0),),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>manageSalon(email)));
              },
            ),
          ),

          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('View my appointments', style: TextStyle(fontSize: 20.0),),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>getSalons(email)));
              },
            ),
          ),
        ]
        )
        ));
  }
}
