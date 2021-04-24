import 'package:elasticcloud/DeleteDeal.dart';
import 'package:elasticcloud/addSalon.dart';
import 'package:elasticcloud/newService.dart';
import 'package:elasticcloud/UpdateService.dart';
import 'package:elasticcloud/ViewServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
import 'viewServicesUpdate.dart';
import 'package:elasticcloud/ViewServicesDelete.dart';
import 'NewDeal.dart';


class manageDeals extends StatelessWidget {
  int _counter = 0;
  final String email;
  final String name;
  manageDeals(this.email, this.name);

  //final firestoreInstance = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text(('Deals Management')),),
        body: Center(child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('New Deal', style: TextStyle(fontSize: 20.0),),
              color: Colors.deepPurple,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>NewDeal(email, name)));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('Delete Deal', style: TextStyle(fontSize: 20.0),),
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>DeleteDeal(email, name)));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('Discount Service', style: TextStyle(fontSize: 20.0),),
              color: Colors.purple,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>ViewServiceUpdate(email, name)));
              },
            ),
          ),
        ]
        )
        ));
  }
}
