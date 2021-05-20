//import 'customerDashboard.dart';

import 'package:sw_engr_project/customerNavBar.dart';
import 'package:sw_engr_project/ownerNavBar.dart';

import 'ManageSalon.dart';
import 'addSalon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
import 'ownerNavBar.dart';
import 'employeeNavBar.dart';
final firestoreInstance = FirebaseFirestore.instance;

class SalonOwnerDashboard extends StatelessWidget {

  final email;
  SalonOwnerDashboard(this.email);

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.deepPurple[700],),
        // floatingActionButton: FloatingActionButton(child: Icon(Icons.add),
        //   onPressed: (){
        //     Navigator.push(context,MaterialPageRoute(builder: (_)=>addSalonOwner()));
        //   },),
      drawer: OwnerNavDrawer(email),
      backgroundColor: Colors.deepPurple[700],
        body: SingleChildScrollView( child: Center(

        child: Column(
            children: <Widget>[
              Container(
                child: new Stack(
                  children: <Widget>[

                    new Positioned(child:
                    Container(
                      //color: Colors.deepPurple[700],
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 120, 180, 50),
                        child: Text('Salon Dashboard', style: TextStyle(fontSize: 30.0, color: Colors.white),),
                        color: Colors.deepPurple[700],
                      ),
                    ),
                    ),])),
              Container(child: new Stack(
                  children: <Widget>[
                    new Positioned(child:
                    Container(
                      //padding:  EdgeInsets.fromLTRB(0, 400, 0, 0),
                      height: 1000,
                      width: 500,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(
                            color: Color(0xffE1D7F7).withOpacity(0.1) ,
                          ),
                          color: Color(0xffE1D7F7).withOpacity(1)
                      ),

                  )),
                  new Positioned(child:
                  Column(
                    //padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                      //child: ListTile(
                      //title: Row(
                      children: <Widget>[
                        SizedBox(height: 90),
                        Row( children: <Widget>[
                      Expanded(
                        child:Card(
                          elevation: 20,
                              color: Colors.yellow[900].withOpacity(0.6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                         ListTile(
                                          leading: GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: () {Navigator.push(context,MaterialPageRoute(builder: (_)=>getSalonOwner(email)));},
                                            child: Container(
                                              width: 48,
                                              height: 48,
                                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                                              alignment: Alignment.center,
                                              child: const CircleAvatar(backgroundImage: AssetImage("assets/images/menuNavBar4.png"),),
                                            ),
                                          ),
                                          title: Text('Owner Details'),
                                          subtitle: Text('View Owner Details'),
                                          trailing: Icon(Icons.account_circle_rounded),

                                        ),
                                      ],
                                    ),
                        )
                      ),
                        Expanded(
                            child:Card(
                              elevation: 20,
                              color: Colors.yellow[900].withOpacity(0.6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {Navigator.push(context,MaterialPageRoute(builder: (_)=>manageSalon(email)));},
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        alignment: Alignment.center,
                                        child: const CircleAvatar(backgroundImage: AssetImage("assets/images/menuNavBar4.png"),),
                                      ),
                                    ),
                                    title: Text('Manage Salon'),
                                    subtitle: Text('Services & Employee'),
                                    trailing: Icon(Icons.add_business_sharp),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ]),
                      SizedBox(height: 50),
                      Row( children: <Widget>[
                            Expanded(
                            child:Card(
                              elevation: 20,
                              color: Colors.yellow[900].withOpacity(0.6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                              leading: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {Navigator.push(context,MaterialPageRoute(builder: (_)=>addSalon(email)));},
                                  child: Container(
                                  width: 48,
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  alignment: Alignment.center,
                                  child: const CircleAvatar(backgroundImage: AssetImage("assets/images/menuNavBar4.png"),),
                                  ),
                              ),
                              title: Text('Add Salon'),
                              subtitle: Text('Insert Salons Info'),
                              trailing: Icon(Icons.add),

                            ),
                            ],
                           ),
                           )
                        ),
                            Expanded(
                            child:Card(
                              elevation: 20,
                              color: Colors.yellow[900].withOpacity(0.6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Column(
                             mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                              ListTile(
                                leading: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {Navigator.push(context,MaterialPageRoute(builder: (_)=>getSalons(email)));},
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    alignment: Alignment.center,
                                    child: const CircleAvatar(backgroundImage: AssetImage("assets/images/menuNavBar4.png"),),
                                  ),
                                ),
                                title: Text('Check Appointments'),
                                subtitle: Text('View Appts'),
                                trailing: Icon(Icons.access_alarm),
                                ),
                              ],
                              ),
                            )
                            ),
                      ])
                      ])),
                  ])),

                      ]
                  ))
        ));
  }
}
