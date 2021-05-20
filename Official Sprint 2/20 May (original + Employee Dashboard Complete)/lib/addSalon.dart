import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:date_format/date_format.dart';

import 'package:location/location.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:elastic_client/console_http_transport.dart';
import 'package:elastic_client/elastic_client.dart' as elastic;
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';

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
class addSalon extends StatefulWidget{
  final String email;
  String Id;
  addSalon(this.email);

  AddSalon createState()=> AddSalon(this.email);

}

class AddSalon extends State<addSalon>{
  final String email;
  String Id;
  AddSalon(this.email);

  double long;
  double lat;

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();

  double _height;
  double _width;

  double dw, dh;
  String _setTime;

  String _hour, _minute, _time,_chour, _cminute, _ctime;

  String dateTime;

  TimeOfDay opening = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay closing = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController openingtimeController = TextEditingController();
  TextEditingController closingtimeController = TextEditingController();

  @override
  void initState() {


    openingtimeController.text = formatDate(
        DateTime(2021, 4, 14, 10, 00),
        [hh, ':', nn, " ", am]).toString();
    closingtimeController.text = formatDate(
        DateTime(2021, 4, 14, 10, 00),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }


  CollectionReference salonRef = firestoreInstance.collection("Salon");

  addToElastic() async{

    final transport = ConsoleHttpTransport(Uri.parse('http://192.168.10.12:9200/'));
    final client = elastic.Client(transport);
    final mappingJson = "{\"settings\":{\"analysis\":{\"filter\":{\"autocomplete_filter\":{\"type\":\"edge_ngram\",\"min_gram\":1,\"max_gram\":20}},\"analyzer\":{\"autocomplete\":{\"type\":\"custom\",\"tokenizer\":\"standard\",\"filter\":[\"lowercase\",\"autocomplete_filter\"]}}}},\"mappings\":{\"properties\":{\"name\":{\"type\":\"text\",\"analyzer\":\"autocomplete\",\"search_analyzer\":\"standard\"},\"location\":{\"type\": \"geo_point\"}}}}";
    Map valueMap = json.decode(mappingJson);

    await client.updateIndex('salons', valueMap);
    final r1= await client.updateDoc('salons', '_doc', name.text,
        {  'name': name.text,
          'address': address.text,
          'location': [double.parse(longitude.text), double.parse(latitude.text)],
          'owner': email,
          //'opening': new DateTime(2021,4,24,opening.hour, opening.minute),
          /*'closing': new DateTime(2021,4,24,closing.hour, closing.minute) */   });
    print("ADDED To Elastic Search "+ r1.toString());

  }
  Future<Null> _selectOpeningTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: opening,
    );
    if (picked != null)
      setState(() {
        opening = picked;
        _hour = opening.hour.toString();
        _minute = opening.minute.toString();
        _time = _hour + ' : ' + _minute;
        openingtimeController.text = _time;
      });}

  Future<Null> _selectClosingTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: closing,
    );
    if (picked != null)
      setState(() {
        closing = picked;
        _chour = closing.hour.toString();
        _cminute = closing.minute.toString();
        _ctime = _chour + ' : ' + _cminute;
        closingtimeController.text = _ctime;
      });}



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        actions:[
          FlatButton(onPressed: (){
            //inserting into elastic search



            final docRef= salonRef.doc(name.text).set({
              //'name': name.text,
              'address': address.text,
              'location': GeoPoint(double.parse(latitude.text), double.parse(longitude.text)),
              'owner': email,
              'opening': new DateTime(2021,4,24,opening.hour, opening.minute),
              'closing': new DateTime(2021,4,24,closing.hour, closing.minute),
              'visitCount': 0

            });

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
          Container(
            width: _width,
            height: _height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Choose Opening Time',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0),
                    ),
                    InkWell(
                      onTap: () {
                        _selectOpeningTime(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        width: 250,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                          onSaved: (String val) {
                            _setTime = val;
                          },
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: openingtimeController,
                          decoration: InputDecoration(
                              disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                              // labelText: 'Time',
                              contentPadding: EdgeInsets.only(top:1, bottom:13)),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Choose Closing Time',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0),
                    ),
                    InkWell(
                      onTap: () {
                        _selectClosingTime(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        width: 250,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                          onSaved: (String val) {
                            _setTime = val;
                          },
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: closingtimeController,
                          decoration: InputDecoration(
                              disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                              // labelText: 'Time',
                              contentPadding: EdgeInsets.only(top:1, bottom:13)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}