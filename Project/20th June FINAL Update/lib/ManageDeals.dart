import 'DeleteDeal.dart';
import 'addSalon.dart';
import 'newService.dart';
import 'UpdateService.dart';
import 'ViewServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
import 'viewServicesUpdate.dart';
import 'ViewServicesDelete.dart';
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.white.withOpacity(0.0),title:Text(('Deals Management')),),

        body:Stack(
            children: <Widget>[
        new Container(
        decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/7-100.jpg"), fit: BoxFit.fill)),
    )
    , Center(child: Column(children: <Widget>[
                SizedBox(width: 400, height: 100,),
          Container(

            margin: EdgeInsets.all(25),
            child: FlatButton(
              padding:EdgeInsets.symmetric(horizontal: 55.0,vertical: 15.0),

              splashColor: Color(0xffe7b7cb),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),

              ),

              color: Color(0xff5c3248),
              child: Text('New Deal', style: TextStyle(fontSize: 20.0),),

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
              padding:EdgeInsets.symmetric(horizontal: 45.0,vertical: 15.0),

              splashColor: Color(0xffe7b7cb),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),

              ),

              color: Color(0xff8c4b83),
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
              padding:EdgeInsets.symmetric(horizontal: 22.0,vertical: 15.0),

              splashColor: Color(0xffe7b7cb),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),

              ),

              color: Color(0xff5c3248),
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>ViewServiceUpdate(email, name)));
              },
            ),
          ),
        ]
        )
        )]));
  }
}
