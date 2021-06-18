import 'addSalon.dart';
import 'ManageServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
//import "EmployeeDashboard.dart";
final firestoreInstance = FirebaseFirestore.instance;
List<String> EmployeeNames = [];


class AssignEmployee extends StatefulWidget{

final String appointment;

AssignEmployee(this.appointment);
@override
_AssignEmployee createState() => _AssignEmployee(this.appointment);
}
/////////////////////

class _AssignEmployee extends State<AssignEmployee> {
  Future<int> getEmployeeNames(appointment) async {
    firestoreInstance.collection("Salon").doc(appointment.split(" ")[1]).collection("Employees").get().then((querySnapshot){
      setState(() {
      final allData = querySnapshot.docs.map((doc) => doc.data()['name'].toString()).toList();
      EmployeeNames = allData;
      });
      return 1;
    });
  }
  @override
  void initState() {

    getEmployeeNames(appointment);
    print("thiiiss");
    print(EmployeeNames);
  }
  final String appointment;

  _AssignEmployee(this.appointment) {

  }

  bool available = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text("Assign This Appointment to"),
        //   backgroundColor: Colors.deepPurple[700],),
        body:Stack(
            children: <Widget>[
        new Container(
        decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/assignemployee-100.jpg"), fit: BoxFit.fill)),
    ),
        Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              SizedBox(width: 400, height: 150,),
              Container( child:
              Text(
                "Assign To",
                style: TextStyle(fontSize: 18),
              ),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),),

              new DropdownButton<String>(
                items: EmployeeNames.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String val) {
                  String username = val.replaceAll(' ', '');
                  firestoreInstance.collection("Appointments").doc(appointment.split(" ")[0]).update({
                    "employee": username,

                  }).then((_) {
                    Navigator.of(context).pop();
                    print("success!");
                  });

                },
              )
            ]
        )
    ]) );
  }
}
//