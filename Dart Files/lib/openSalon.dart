import 'package:elasticcloud/bar_chart_demo.dart';
import 'package:elasticcloud/empPerformance.dart';
import 'package:flutter/rendering.dart';

import 'ManageDeals.dart';
import 'addSalon.dart';
import 'ManageServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
import 'alertDialog.dart';
import 'createEmployee.dart';

TextEditingController name = TextEditingController();

bool valid=true;
bool belongs=true;
String message="";
final firestoreInstance = FirebaseFirestore.instance;
final Color oddItemColor = Colors.deepPurple.withOpacity(0.05);
final Color evenItemColor = Colors.deepPurple.withOpacity(0.15);

List<String> EmployeeNames = [];

void _showDialog(BuildContext context, String service) {
  print("In Dialog");
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Oops!"),
        content: new Text(service),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            color: Colors.deepPurple[200],
            child: new Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

        ],
      );
    },
  );
}


Future<bool> checkSalon(String email, String name) async {

  var document= await firestoreInstance.collection("Salon").doc(name).get();
  if (document.exists)
    valid=true;
  else {
    valid = false;
    message="This Salon Does Not Exist";
  }
  return valid;
}
Future<bool> checkEmail(String email, String name) async{
  var document= await firestoreInstance.collection("Salon").doc(name).get();
  String aemail=document.data()["owner"];
  if (aemail != email){
    belongs=false;
    message="Nice Try! This isnt your Salon";
  }
  else
    belongs=true;
}

class openSalon extends StatefulWidget{
  final String email;
  openSalon(this.email);
  @override
  OpenSalon createState() => OpenSalon(this.email);

}

class OpenSalon extends State<openSalon> {
  final String email;
  OpenSalon(this.email);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text(('Employee Performance')),
          backgroundColor: Colors.deepPurple[700],
        ),
        body: SingleChildScrollView( child: Center(
            child: Column(
                children: <Widget>[
                  new Container(
                    width: 300.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: TextField(
                      controller: name,
                      textAlign: TextAlign.left,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(

                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        prefixIcon: Icon(Icons.apartment,
                          color: Colors.deepPurple[200],),
                        filled: true,
                        hintText: 'Salon Name',
                        //border: InputBorder.none,
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  ),
                  new Column(children: [
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Expanded(child: RaisedButton(
                              onPressed: () async {

                                var xyz= await checkSalon(email, name.text); //this checks if salon exists
                                //need to add check that it also belongs to the user
                                if (valid) {

                                  var abc= await checkEmail(email, name.text);
                                  if (belongs) {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => EmpBarChart(email, name.text)));
                                  }
                                  else
                                    _showDialog(context, message);
                                }
                                else {
                                  _showDialog(context, message);
                                }
                              },
                              child: Text("View Performance"),
                              color: Colors.purple[50])),
                          SizedBox(width: 10),
                        ],
                      ),
                    )
                  ]),
                ])
        )

        ));
  }

}
