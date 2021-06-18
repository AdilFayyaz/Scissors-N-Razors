//import 'customerDashboard.dart';

import 'customerNavBar.dart';
import 'ownerNavBar.dart';

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
      extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.white.withOpacity(0.0)),
        // floatingActionButton: FloatingActionButton(child: Icon(Icons.add),
        //   onPressed: (){
        //     Navigator.push(context,MaterialPageRoute(builder: (_)=>addSalonOwner()));
        //   },),
       drawer: OwnerNavDrawer(email),
       backgroundColor: Colors.deepPurple[700],
        body: Stack(
            children: <Widget>[
        new Container(
        decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/salon dashboard-100.jpeg"), fit: BoxFit.fill)),
    )
    , SingleChildScrollView( child: Center(

        child: Column(
            children: <Widget>[
              SizedBox(width: 400, height: 370,),
              // Container(
              //   child: new Stack(
              //     children: <Widget>[
              //
              //       new Positioned(child:
              //       Container(
              //         //color: Colors.deepPurple[700],
              //         child: Container(
              //           padding: EdgeInsets.fromLTRB(10, 100, 100, 20),
              //           child: Text('Salon Dashboard', style: TextStyle(fontSize: 30.0, color: Colors.white),),
              //           color: Colors.deepPurple[700],
              //         ),
              //       ),
              //       ),])),
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
                            color: Color(0xff8c4b83).withOpacity(0.1) ,
                          ),
                          color: Color(0xff8c4b83).withOpacity(1)
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
                              color: Color(0xff253976).withOpacity(0.6),
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
                                          title: Text('Owner Details' ,style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  ),),
                                          subtitle: Text('View Owner Details',style: TextStyle(
                                            color: Colors.white,
                                              fontSize: 10,
                                          ),),
                                          trailing: Icon(Icons.account_circle_rounded,color: Colors.white),

                                        ),
                                      ],
                                    ),
                        )
                      ),
                        Expanded(
                            child:Card(
                              elevation: 20,
                              color: Color(0xff253976).withOpacity(0.6),
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
                                    title: Text('Manage Salon',style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),),
                                    subtitle: Text('Services & Employee',style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),),
                                    trailing: Icon(Icons.add_business_sharp,color: Colors.white),
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
                              color: Color(0xff253976).withOpacity(0.6),
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
                              title: Text('Add Salon',style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),),
                              subtitle: Text('Insert Salons Info',style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),),
                              trailing: Icon(Icons.add,color: Colors.white),

                            ),
                            ],
                           ),
                           )
                        ),
                            Expanded(
                            child:Card(
                              elevation: 20,
                              color: Color(0xff253976).withOpacity(0.6),
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
                                title: Text('Check Appointments',style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),),
                                subtitle: Text('View Appts',style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),),
                                trailing: Icon(Icons.access_alarm,color: Colors.white),
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
        )]));
  }
}
