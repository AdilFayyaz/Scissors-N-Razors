import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elasticcloud/alertDialog.dart';
import 'customerDashboard.dart';
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
//List<String> AllServices=[];

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
  @override
  void initState() {
    AllServices.clear();
    getAllServices(salonname);
    super.initState();
  }
  var AllServices  =<Map>[];
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
        extendBodyBehindAppBar: true,
    appBar: AppBar(backgroundColor: Colors.white.withOpacity(0.0)),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
        child: Container(
              decoration: BoxDecoration(
              image: DecorationImage(
              image: AssetImage("assets/images/3-100.jpg"),
              fit: BoxFit.cover,
              ),
              ),
            child: Center(

            child: Column(
                children: <Widget>[
                  SizedBox(height: 40,),
                  new Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child:
                      Text(
                        "Tap on a Service to Add to Cart",
                        style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                  ),
                  new Container(
                      child: Text(
                        salonname,
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
                      ),),
                  new Container(
                          child: Text(
                            'You can select max 3 services',
                            style: TextStyle(fontSize: 15,color: Colors.white),
                          ),),
                  SizedBox(height: 50,),
                  new Container(
                    //color: Colors.grey[100],
                    height: 300,
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
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: new ListView.builder(

                                itemCount:this.AllServices.length,
                                padding: EdgeInsets.symmetric(vertical: 25.0),
                                itemBuilder: (BuildContext context, int index) =>
                                    Container(
                                      child: ListTile(
                                        leading: const Icon(Icons.face_unlock_outlined,
                                          color: Colors.deepPurple,),
                                        title: Text(
                                          this.AllServices[index]['Service']

                                        ),
                                        subtitle: Text(this.AllServices[index]['Description'] +" Price: "+ this.AllServices[index]['Price'] ) ,
                                        onTap: () async{
                                          setState((){
                                            var map = {};
                                            map['Service'] =  this.AllServices[index]['Service'];
                                            map['Price'] =  this.AllServices[index]['Price'];
                                            total =  int.parse(map['Price']) + total;
                                            getCart(map,cart);
                                          });
                                        },
                                      ),

                                    ),

                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  new Container(
                    //color: Colors.grey[100],
                    height: 200,
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
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: new ListView.builder(

                                itemCount:cart.length,
                                padding: EdgeInsets.symmetric(vertical: 25.0),
                                itemBuilder: (BuildContext context, int index) =>
                                    Container(
                                      child: ListTile(
                                        leading: const Icon(Icons.delete,
                                          color: Colors.deepPurple,),
                                        title: Text(
                                            this.cart[index]['Service']
                                        ),
                                        subtitle: Text(" Price: "+ this.cart[index]['Price'] ) ,
                                        onTap: () async{

                                        },
                                      ),

                                    ),

                              ),
                            )
                        )
                      ],
                    ),
                  ),
        Container(
                child: Column(
                children:[

                  Container(
                    child:
                        FlatButton(onPressed: () => {
                        setState((){
                          total = total - int.parse(cart[cart.length-1]['Price']);
                          cart.removeAt(cart.length-1);
                        }),

                        }, child: Text('Remove', style: TextStyle(fontSize: 20.0, color: Colors.white),),
                        color: Color(0xff133579)
                ),
                  ),
        ],),),
      Container(
                    child: Text('Total Bill: ' + total.toString(), style: TextStyle(fontSize: 20.0),)
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: FlatButton(
                    child: Text('Get an Appointment', style: TextStyle(fontSize: 20.0),),
                    color:  Color(0xff133579),
                    textColor: Colors.white,
                    onPressed: () {
                      if (cart.length<=0){
                        DialogBox d= new DialogBox();
                        d.showDialogInfo(context, "Empty Cart", "Select some service first please!");
                      }
                      else if(cart.length>3){
                        DialogBox d= new DialogBox();
                        d.showDialogInfo(context, "Limit Crossed", "You can only select 3 or less services!");
                      }
                      else {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) =>
                                bookAppointment(cart, salonname, email)));
                        //setState(() {
                          //cart.clear();
                          //cart.length = 0;
                          //total = 0;
                        //});
                      }}),
                        ),

                ]))))
    ));


  }
  Future<int> getAllServices(String salonname) async {
    firestoreInstance.collection("Salon").doc(salonname).collection('Services').get().then((querySnapshot) {
      setState(() {
        querySnapshot.docs.forEach((res) {
          if(res.data()['available'] == true) {
            var tempService = {};
            tempService['Service']  = res.id;
            tempService['Description'] = res.data()['description'].toString();
            tempService['Price'] = res.data()['price'].toString();
            this.AllServices.add(tempService);
          }
        });
      });
      return 1;
    });
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