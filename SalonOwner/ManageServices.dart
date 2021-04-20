import 'package:elasticcloud/addSalon.dart';
import 'package:elasticcloud/newService.dart';
import 'package:elasticcloud/UpdateService.dart';
import 'package:elasticcloud/ViewServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:elasticcloud/DeleteService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';


class manageServices extends StatelessWidget {
  int _counter = 0;
  final String email;
  final String name;
  manageServices(this.email, this.name);

  //final firestoreInstance = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text(('Services Management')),),
        body: Center(child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('New Service', style: TextStyle(fontSize: 20.0),),
              color: Colors.deepPurple,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>NewService(email, name)));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('Delete Service', style: TextStyle(fontSize: 20.0),),
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>DelService(email, name)));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('Update Service', style: TextStyle(fontSize: 20.0),),
              color: Colors.purple,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>UpdateService(email, name)));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('View Services', style: TextStyle(fontSize: 20.0),),
              color: Colors.purpleAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>ViewService(email, name)));
              },
            ),
          ),
        ]
        )
        ));
  }
}
