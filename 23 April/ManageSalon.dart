import 'package:elasticcloud/ManageDeals.dart';
import 'package:elasticcloud/addSalon.dart';
import 'package:elasticcloud/ManageServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
bool valid=false;
final firestoreInstance = FirebaseFirestore.instance;
Future<bool> checkSalon(String email, String name) async {

  var document= await firestoreInstance.collection("Salon").doc(name).get();
  if (document.exists)
    valid=true;
  else
    valid=false;
  return valid;
}

class manageSalon extends StatefulWidget{
  final String email;
  manageSalon(this.email);
  @override
  ManageSalon createState() => ManageSalon(this.email);

}

class ManageSalon extends State<manageSalon> {
  String msg="";
  int _counter = 0;
  final String email;
  ManageSalon(this.email);

  //final firestoreInstance = FirebaseFirestore.instance;
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text(('Salon Management')),),
        body: Center(child: Column(children: <Widget>[
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: name,
                decoration: InputDecoration(hintText: 'Salon Name')
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('Manage Services', style: TextStyle(fontSize: 20.0),),
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,
              onPressed: () {
                checkSalon(email, name.text); //this checks if salon exists
                //need to add check that it also belongs to the user
                if (valid) {
                  setState((){
                    msg="";
                  });
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => manageServices(email, name.text)));
                }
                else {
                  setState(() {
                    msg = "No Such Salon";
                  });
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('Manage Deals', style: TextStyle(fontSize: 20.0),),
              color: Colors.purpleAccent,
              textColor: Colors.white,
              onPressed: () {
                checkSalon(email, name.text); //this checks if salon exists
                //need to add check that it also belongs to the user
                if (valid) {
                  setState((){
                    msg="";
                  });
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => manageDeals(email, name.text)));
                }
                else {
                  setState(() {
                    msg = "No Such Salon";
                  });
                }
              },
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
