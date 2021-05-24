import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ManageSalon.dart';
TextEditingController EmpName = TextEditingController();
final firestoreInstance = FirebaseFirestore.instance;


Future<void> addNewEmployeeAccount(BuildContext context, String SalonName) async{

  // flutter defined function
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text('Add Employee Details to Create Account'),
            content: new TextField(
              controller: EmpName,
              textAlign: TextAlign.left,
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(Icons.account_circle_outlined,
                  color: Colors.deepPurple[200],),
                filled: true,
                hintText: 'Employee Name',
                //border: InputBorder.none,
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Add Employee"),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurple[200]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.deepPurple[200])
                        )
                    )
                ),
                onPressed: () async {
                  CollectionReference salonRef = firestoreInstance.collection(
                      "Salon").doc(SalonName).collection("Employees");
                  // Make a Username for the employee
                  String username = EmpName.text.replaceAll(' ', '');
                  Random rnd = new Random();
                  String password = rnd.nextInt(100).toString() + username +
                      rnd.nextInt(100).toString();
                  final docRef = salonRef.doc(username).set({
                    'name': EmpName.text,
                    'password': password,
                  });
                  // }).whenComplete(() =>setState(() {
                  //   getEmployeeNames();
                  // })
                  // );
                  //EmployeeNames.add(EmpName.text + ", Password" + password);

                  Navigator.of(context).pop();
                },
              ),

            ],
          );
        });
    },
  );
}