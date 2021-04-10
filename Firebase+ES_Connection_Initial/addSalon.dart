import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:elastic_client/console_http_transport.dart';
import 'package:elastic_client/elastic_client.dart' as elastic;
import 'package:http/http.dart' as http;

final firestoreInstance = FirebaseFirestore.instance;
Location location= new Location();
LocationData _currentPosition;
getLoc() async{
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _currentPosition = await location.getLocation();
}


class addSalon extends StatelessWidget{
  final String email;
  String Id;
  addSalon(this.email);

  double long;
  double lat;

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();


  CollectionReference salonRef = firestoreInstance.collection("Salon");

  addToElastic() async{

    final transport = ConsoleHttpTransport(Uri.parse('http://192.168.18.18:9200/'));
    final client = elastic.Client(transport);
    final mappingJson = "{\"settings\":{\"analysis\":{\"filter\":{\"autocomplete_filter\":{\"type\":\"edge_ngram\",\"min_gram\":1,\"max_gram\":20}},\"analyzer\":{\"autocomplete\":{\"type\":\"custom\",\"tokenizer\":\"standard\",\"filter\":[\"lowercase\",\"autocomplete_filter\"]}}}},\"mappings\":{\"properties\":{\"name\":{\"type\":\"text\",\"analyzer\":\"autocomplete\",\"search_analyzer\":\"standard\"},\"location\":{\"type\": \"geo_point\"}}}}";
    Map valueMap = json.decode(mappingJson);

    await client.updateIndex('salons', valueMap);
    final r1= await client.updateDoc('salons', '_doc',Id,
        {'name': name.text,
          'address': address.text,
          'location': [double.parse(longitude.text), double.parse(latitude.text)],
          'owner': email});
    print("ADDED To Elastic Search "+ r1.toString());

  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        actions:[
          FlatButton(onPressed: (){
            //inserting into elastic search



            final docRef= salonRef.add({
              'name': name.text,
              'address': address.text,
              'location': GeoPoint(double.parse(latitude.text), double.parse(longitude.text)),
              'owner': email

            }).then((value) => Id=value.id);

            //adding to elasticsearch into an n-gram type index
            addToElastic().whenComplete(() => Navigator.pop(context));

          },child:Text('Save'))
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: name,
                decoration: InputDecoration(hintText: 'Salon Name')
            ),
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: address,
                decoration: InputDecoration(hintText: 'Address')
            ),
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
              controller: longitude,
              decoration: InputDecoration(hintText: 'Longitude'),
              autofocus: true,
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
              controller: latitude,
              decoration: InputDecoration(hintText:'Latitude'),
              autofocus: true,
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text('getCurrentLocationInstead', style: TextStyle(fontSize: 20.0),),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                getLoc();
                longitude.text=_currentPosition.longitude.toString();
                latitude.text=_currentPosition.latitude.toString();


              },
            ),
          ),
        ],
      ),
    );
  }
}