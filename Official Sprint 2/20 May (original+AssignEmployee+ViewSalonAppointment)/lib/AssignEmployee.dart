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
Future<int> getEmployeeNames(appointment) async {
  firestoreInstance.collection("Salon").doc(appointment.split(" ")[1]).collection("Employees").get().then((querySnapshot){
    final allData = querySnapshot.docs.map((doc) => doc.data()['name'].toString()).toList();
    EmployeeNames = allData;
    return 1;
  });
}

class AssignEmployee extends StatefulWidget{

final String appointment;

AssignEmployee(this.appointment);
@override
_AssignEmployee createState() => _AssignEmployee(this.appointment);
}
/////////////////////

class _AssignEmployee extends State<AssignEmployee> {
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
        appBar: AppBar(title: Text("Assign This Appointment to"),),
        body:
        Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Text(
                "Assign to",
                style: TextStyle(fontSize: 18),
              ),
              new DropdownButton<String>(
                items: EmployeeNames.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String val) {
                  firestoreInstance.collection("Appointments").doc(appointment.split(" ")[0]).update({
                    "employee": val,

                  }).then((_) {
                    print("success!");
                  });

                },
              )
            ]
        )
    );
  }
}
//