import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalonModel {
  static List<String> Services = [];
  static List<String> Deals  = [];
  static final firestoreInstance = FirebaseFirestore.instance;
  static void addSalonService(String serviceName, int price){
    // Add to Salon Services List and Update the DB
    Services.add(serviceName);
    CollectionReference salonRef = firestoreInstance.collection("Salon").doc("TestSalon").collection("Services");
    final docRef= salonRef.doc(serviceName).set({
      'price': price,
    });
  }

  static void addSalonDeals(String dealName){
    //Add to Salon Deals List and Update the DB
    Deals.add(dealName);
  }
  
}

class SalonController extends ControllerMVC {
  factory SalonController() {
    if (_this == null) _this = SalonController._();
    return _this;
  }
  static SalonController _this;

  SalonController._();

  List<String> get SalonServices => SalonModel.Services;
  void addService(String serviceName, int price) {
    SalonModel.addSalonService(serviceName, price);
  }

  void addDeals(String dealname) {
    SalonModel.addSalonDeals(dealname);
  }

}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // Fields in a Widget subclass are always marked "final".

  final String title = 'MVC Demo';
  final String title1 = 'Push Buttons to increase and decrease value.';

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final SalonController _con = SalonController();
  TextEditingController name = new TextEditingController();
  TextEditingController price = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(('Salon Management')),
        backgroundColor: Colors.deepPurple[700],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10, 60, 10, 0),
              child: new ListView.builder(

                itemCount: _con.SalonServices.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(vertical: 25.0),
                itemBuilder: (BuildContext context, int index) =>
                    Container(
                      child: ListTile(
                        leading: const Icon(Icons.add,
                          color: Colors.deepPurple,),
                        title: Text(
                            _con.SalonServices[index]
                        ),
                        
                      ),

                    ),
              ),
            ),
            Container(
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
                  hintText: 'Service Name',
                  //border: InputBorder.none,
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            ),
            Container(
              width: 300.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              child: TextField(
                controller: price,
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
                  hintText: 'Service Price',
                  //border: InputBorder.none,
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            ),
            Container(
              child: RaisedButton(
                  onPressed: () async {
                    setState(() {
                      _con.addService(name.text, int.parse(price.text));
                    });
                    name.clear();
                  },
                  child: Text("Add Services"),
                  color: Colors.purple[50]),
            ),

            ],
            ),
        ),
    );
  }
}