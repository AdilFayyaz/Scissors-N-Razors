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

bool valid=false;
TextEditingController name = TextEditingController();
final firestoreInstance = FirebaseFirestore.instance;
final Color oddItemColor = Colors.deepPurple.withOpacity(0.05);
final Color evenItemColor = Colors.deepPurple.withOpacity(0.15);

List<String> EmployeeNames = [];
Future<int> getEmployeeNames() async {
  firestoreInstance.collection("Salon").doc(name.text).collection("Employees").get().then((querySnapshot){
    final allData = querySnapshot.docs.map((doc) => doc.data()['name'].toString() + ", Password: " + doc.data()['password'].toString()).toList();
    EmployeeNames = allData;
    return 1;
  });
}


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text(('Salon Management')),
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
                    onPressed: () {
                    checkSalon(email, name.text); //this checks if salon exists
                          //need to add check that it also belongs to the user
                    if (valid) {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => manageServices(email, name.text)));
                    }
                    else {
                      showDialogInfo(context, "No Such Salon");
                    }
                  },
                    child: Text("Manage Services"),
                    color: Colors.purple[50])),
                  SizedBox(width: 10),
                  Expanded(
                      child: RaisedButton(onPressed: (){
                    checkSalon(email, name.text); //this checks if salon exists
                          //need to add check that it also belongs to the user
                          if (valid) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_) => manageDeals(email, name.text)));
                          }
                          else {
                            showDialogInfo(context, "No Such Salon");
                          }
                  },child: Text("Manage Deals"),
                    color: Colors.purple[50])),
                ],
              ),
            )
          ]),

          //////////////////Added New tiles here//////////////////
            Column(
                children: <Widget>[

                  new Column(children: [
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Expanded(child: RaisedButton(
                              onPressed: () async{
                                  checkSalon(email, name.text);

                                //need to add check that it also belongs to the user
                                if (valid) {
                                  setState(() {
                                    // get list of emp names, and passwords
                                    getEmployeeNames();
                                  });
                                  for (var i = 0; i< EmployeeNames.length; i++)
                                    print(EmployeeNames[i]);
                                }
                                else {
                                  showDialogInfo(context, "No Such Salon");
                                }
                              },
                              child: Text("View Employees"),
                              color: Colors.purple[50])),
                          SizedBox(width: 10),
                          Expanded(
                              child: RaisedButton(onPressed: (){
                                checkSalon(email, name.text); //this checks if salon exists
                                //need to add check that it also belongs to the user
                                if (valid) {
                                  // Navigator.push(context, MaterialPageRoute(
                                  //     builder: (_) => manageDeals(email, name.text)));
                                }
                                else {
                                  showDialogInfo(context, "No Such Salon");
                                }
                              },child: Text("Extra button"),
                                  color: Colors.purple[50])),
                        ],
                      ),
                    )
                  ]),
                    ]),
          //////////////////////////////////////////////
          new Container(
              margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
              child:
              Text(
                "Manage Salon Employees",
              style: TextStyle(color: Colors.deepPurpleAccent,
               fontWeight: FontWeight.bold,
              fontSize: 20,
              ),
            )
          ),
          new Container(
            //color: Colors.grey[100],
            height: 500,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              border: Border.all(
               color: Colors.grey[100],
               ),
              color: Colors.grey[100]
            ),
            child: new Stack(
              children: <Widget>[
              new Positioned(
                child: new Container(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: new Stack(
                    children:<Widget> [
                      ListTile(
                        leading: const Icon(Icons.add),
                        tileColor: evenItemColor,
                        title: Text(
                          'Add New Employee'
                        ),
                        onTap:() async{

                          checkSalon(email, name.text); //this checks if salon exists

                          //need to add check that it also belongs to the user
                          if (valid) {
                            addNewEmployeeAccount(context, name.text).whenComplete(() =>setState(() {
                              getEmployeeNames();
                            })
                            );
                                // setState(() {
                                  print("Added new emp");
                                  //getEmployeeNames();
                                // });
                          }
                          else {
                            showDialogInfo(context, "No Such Salon");
                          }

                        }
                      ),
                    ],
                  ),
                ),
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('$item dismissed')));

              ),
              ),
                new Positioned(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(10, 60, 10, 0),
                    child: new ListView.builder(

                      itemCount: EmployeeNames.length,
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                            child: ListTile(
                              leading: const Icon(Icons.delete,
                                  color: Colors.deepPurple,),
                              title: Text(
                                  EmployeeNames[index]
                              ),
                              onTap: () async{
                                    getEmployeeNames();
                                    CollectionReference salonEmp = firestoreInstance.collection("Salon").doc(name.text).collection("Employees");
                                    String username = EmployeeNames[index];
                                    var emp = username.split(',');
                                    username = emp[0].replaceAll(' ', '');
                                    final docRef = salonEmp.doc(username).delete().whenComplete(() => setState(() {
                                      getEmployeeNames();
                                    })
                                );
                              },
                            ),

                          ),

                    ),
                  )
                )
              ],
            ),


          ),
        ])
        )

        ));
  }
  
}
