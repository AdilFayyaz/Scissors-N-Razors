import 'addSalon.dart';
import 'ManageServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
bool valid=false;
final firestoreInstance = FirebaseFirestore.instance;


class bookAppointment extends StatelessWidget {
  String msg="";
  int _counter = 0;
  var cart = <Map>[];
  final salonname;
  bookAppointment(this.cart,this.salonname);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text(('Salon Management')),),
        body: Center(child: Column(children: <Widget>[

          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('Select Date and Time', style: TextStyle(fontSize: 20.0),),
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,

            ),
          ),
          Container(
              margin: EdgeInsets.all(25),
              width: 50,
              color: Colors.white,
              child: Text(msg,
                style: TextStyle(color: Colors.deepPurpleAccent),
              )
          ),
        ]
        )
        ));
  }
}
