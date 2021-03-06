import 'package:elasticcloud/bar_chart_demo.dart';
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
final Color evenItemColor = Color(0xff253976);//Colors.deepPurple.withOpacity(0.15);

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

class manageSalon extends StatefulWidget{
  final String email;
  manageSalon(this.email);
  @override
  ManageSalon createState() => ManageSalon(this.email);

}

class ManageSalon extends State<manageSalon> {
  void initState(){
    name.clear();
    EmployeeNames.clear();
  }
  Future<int> getEmployeeNames() async {
    firestoreInstance.collection("Salon").doc(name.text).collection("Employees").get().then((querySnapshot){
      setState(() {
      final allData = querySnapshot.docs.map((doc) => doc.data()['name'].toString() + ", Password: " + doc.data()['password'].toString()).toList();
      EmployeeNames = allData;
      });
      return 1;
    });
  }
  String msg="";
  int _counter = 0;
  final String email;
  ManageSalon(this.email);

  @override
  Widget build(BuildContext context) {
    getEmployeeNames();
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(title:Text(('Salon Management')),
            backgroundColor: Colors.white.withOpacity(0.0)


        ),
        body:Stack(
            children: <Widget>[
        new Container(
        decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/1-100.jpg"), fit: BoxFit.fill)),
    )
    , SingleChildScrollView( child: Center(
          child: Column(
          children: <Widget>[
             SizedBox(width: 400, height: 145,),
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
                  color: Color(0xff208694),),
                filled: true,
                hintText: 'Enter Salon Name',
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),

                      ),
                      onPressed: () async {

                        var xyz= await checkSalon(email, name.text); //this checks if salon exists
                        //need to add check that it also belongs to the user
                        if (valid) {

                          var abc= await checkEmail(email, name.text);
                          if (belongs) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_) => manageServices(email, name.text)));
                          }
                          else
                            _showDialog(context, message);
                        }
                        else {
                          _showDialog(context, message);
                        }
                      },
                    child: Text("Manage Services",style: TextStyle(color:Colors.white),),
                    color: Color(0xff208694))),
                  SizedBox(width: 10),
                  Expanded(
                      child: RaisedButton(

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),

                          ),
                          onPressed: () async {

                            var xyz= await checkSalon(email, name.text); //this checks if salon exists
                            //need to add check that it also belongs to the user
                            if (valid) {

                              var abc= await checkEmail(email, name.text);
                              if (belongs) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => manageDeals(email, name.text)));
                              }
                              else
                                _showDialog(context, message);
                            }
                            else {
                              _showDialog(context, message);
                            }
                          },
                          child: Text("Manage Deals",style: TextStyle(color:Colors.white)),
                    color:Color(0xff208694))),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),

                              ),
                              onPressed: () async {
                                valid = true;
                                belongs = true;

                                var xyz= await checkSalon(email, name.text); //this checks if salon exists

                                if (valid) {

                                  var abc= await checkEmail(email, name.text);
                                  if (belongs) {
                                      setState(() {
                                      // get list of emp names, and passwords
                                      getEmployeeNames();
                                    });
                                    for (var i = 0; i< EmployeeNames.length; i++)
                                      print(EmployeeNames[i]);
                                  }
                                  else
                                    _showDialog(context, message);
                                }
                                else {
                                  _showDialog(context, message);
                                }
                              },
                              child: Text("View Employees",style: TextStyle(color:Colors.white)),
                              color: Color(0xff208694))),
                           SizedBox(width: 10),
                          Expanded(
                              child: RaisedButton(

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),

                                  ),
                                  onPressed: () async {
                                    valid = true;
                                    belongs = true;
                                    var xyz= await checkSalon(email, name.text); //this checks if salon exists
                                    //need to add check that it also belongs to the user
                                    if (valid) {
                                      var abc= await checkEmail(email, name.text);
                                      if (belongs) {
                                        setState(() {
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (_) => BarChartDemo(email, name.text)));
                                        });
                                      }
                                      else
                                        _showDialog(context, message);
                                    }
                                    else {
                                      _showDialog(context, message);
                                    }
                                  },
                                  child: Text("View Graphs",style: TextStyle(color:Colors.white)),
                                  color: Color(0xff208694))),
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
              style: TextStyle(color: Color(0xff253976),
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
                          'Add New Employee',style: TextStyle(color:Colors.white)
                        ),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),

                          ),
                          onTap: () async {
                            valid = true;
                            belongs = true;
                            var xyz= await checkSalon(email, name.text); //this checks if salon exists
                            //need to add check that it also belongs to the user
                            if (valid) {

                              var abc= await checkEmail(email, name.text);
                              if (belongs) {
                                addNewEmployeeAccount(context, name.text).whenComplete(() =>setState(() {
                                  getEmployeeNames();
                                })
                                );
                                // setState(() {
                                print("Added new emp");
                                //getEmployeeNames();
                                // });
                              }
                              else
                                _showDialog(context, message);
                            }
                            else {
                              _showDialog(context, message);
                            }
                          },
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
                                  color: Color(0xff208694),),
                              title: Text(
                                  EmployeeNames[index]
                              ),
                              onTap: () async{
                                    getEmployeeNames();
                                    CollectionReference salonEmp = firestoreInstance.collection("Salon").doc(name.text).collection("Employees");
                                    String username = EmployeeNames[index];
                                    var emp = username.split(',');
                                    username = emp[0].replaceAll(' ', '');
                                    // Delete an Employee from the collection
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

        )
    ]));
  }
  
}
