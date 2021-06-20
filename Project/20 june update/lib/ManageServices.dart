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


class manageServices extends StatelessWidget {
  int _counter = 0;
  final String email;
  final String name;
  manageServices(this.email, this.name);

  //final firestoreInstance = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.white.withOpacity(0.0),title:Text(('Services Management')),),
        body: Stack(
            children: <Widget>[
        new Container(
        decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/8-100.jpg"), fit: BoxFit.fill)),
    )
    ,Center(child: Column(children: <Widget>[
                SizedBox(width: 400, height: 100,),
          Container(
            margin: EdgeInsets.all(20),
            child: FlatButton(
              padding:EdgeInsets.symmetric(horizontal: 22.0,vertical: 15.0),

              splashColor: Color(0xff111e4b),
              color: Color(0xff133579),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),

              ),


              child: Text('New Service', style: TextStyle(fontSize: 20.0),),

              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>NewService(email, name)));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: FlatButton(
              padding:EdgeInsets.all(15.0),
              splashColor:Color(0xff133579),
              color: Color(0xff111e4b),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),

              ),

              child: Text('Delete Service', style: TextStyle(fontSize: 20.0),),

              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>ViewServiceDelete(email, name)));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: FlatButton(
              padding:EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
              splashColor: Color(0xff111e4b),
              color: Color(0xff133579),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),

              ),


              child: Text('Update Service', style: TextStyle(fontSize: 20.0),),

              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>ViewServiceUpdate(email, name)));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: FlatButton(
              padding:EdgeInsets.symmetric(horizontal: 22.0,vertical: 15.0),
              splashColor:Color(0xff133579),
              color: Color(0xff111e4b),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),

              ),


              child: Text('View Services', style: TextStyle(fontSize: 20.0),),

              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (_)=>ViewService(email, name)));
              },
            ),
          ),
        ]
        )
        )
  ])  );
  }
}
