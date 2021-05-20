import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elasticcloud/customerDashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:elastic_client/console_http_transport.dart';
import 'package:elastic_client/elastic_client.dart' as elastic;
import 'package:http/http.dart' as http;
import 'bookAppointment.dart';

final firestoreInstance = FirebaseFirestore.instance;
//Map cart[] = Map <String,String>();

Future _getCartMap(map,cart) async{
  cart.add(map);
  return cart.toString();
}

void getCart(map,cart) async{
  cart = await _getCartMap(map,cart);
}
class viewSalon extends StatefulWidget{
  final String salonname;
  final String email;
  viewSalon(this.salonname, this.email);
  @override
  viewSalonList createState() => viewSalonList(this.salonname, this.email);
}

class viewSalonList extends State<viewSalon>{
  var cart = <Map>[];
  int total =0;
  final String salonname;
  final String email;
  String price;
  viewSalonList(this.salonname, this.email);

  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();
  bool available=true;

  @override
  Widget build(BuildContext context){
    // ignore: missing_required_param
    return WillPopScope(
        onWillPop: () {
          print('Backbutton pressed (device or appbar button), do whatever you want.');

          //trigger leaving and use own data
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => customerDashboard(email)));

          //we need to return a future
          return Future.value(false);
        },
    child: Scaffold(
        appBar: AppBar(title:Text((salonname)),),
        body:
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

          Text(
          salonname,
          style: TextStyle(fontSize: 18),
        ),
        Expanded(
        child: StreamBuilder<QuerySnapshot>(
            stream: firestoreInstance.collection("Salon").doc(salonname).collection("Services").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text("There is are no services");

              return new ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(30.0),
                  children: getServiceItems(snapshot));
            }),
        ),
            Expanded(
              child: Container(
                //body: cartWidget(),
                  child: Column(

                  children:[
                    for (var i =0 ; i <cart.length; i++)
                      Text(this.cart[i]['Service'].toString() +" "+this.cart[i]['Price'].toString(), style: TextStyle(fontSize: 20.0)),
                    Container(
                      child:
                          FlatButton(onPressed: () => {
                          setState((){
                            total = total - int.parse(cart[cart.length-1]['Price']);
                            cart.removeAt(cart.length-1);
                          }),

                          },
                              child: Text('Remove', style: TextStyle(fontSize: 20.0),),
                          color: Colors.deepPurple[300]


                  ),
                    ),


                ],

              ),
              ),

            ),
            Container(
                child: Text('Total Bill: ' + total.toString(), style: TextStyle(fontSize: 20.0),)
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('Get an Appointment', style: TextStyle(fontSize: 20.0),),
                color: Colors.deepPurple[800],
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (_)=>bookAppointment(cart,salonname, email)));
                },
              ),
            ),
      ])
    ),
    );


  }
  getServiceItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => new ListTile(title: new Text(doc.id), onTap: (){
        setState((){
            var map = {};
            map['Service'] = doc.id;
            map['Price'] = doc.data()["price"].toString();
            total =  int.parse(doc.data()["price"]) + total;
            getCart(map,cart);
        });
            //cart.add(map);
        },
        subtitle: Column(
          children: <Widget>[
            new Text(doc.data()["description"].toString()),
            new Text("Price: " + doc.data()["price"].toString())
        ],
    )))
        .toList();
  }


}