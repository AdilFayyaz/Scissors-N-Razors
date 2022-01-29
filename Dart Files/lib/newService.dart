import 'package:cloud_firestore/cloud_firestore.dart';
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

final firestoreInstance = FirebaseFirestore.instance;

class NewService extends StatefulWidget{
  final String email;
  final String salonname;
  NewService(this.email, this.salonname);
  @override
  newService createState() => newService(this.email, this.salonname);
}

class newService extends State<NewService>{
  final String email;
  final String salonname;
  String Id;
  newService(this.email, this.salonname);

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController desc = TextEditingController();
  bool available=true;




  addToElastic() async{

    final transport = ConsoleHttpTransport(Uri.parse('http://192.168.18.18:9200/'));
    final client = elastic.Client(transport);
    final mappingJson = "{\"settings\":{\"analysis\":{\"filter\":{\"autocomplete_filter\":{\"type\":\"edge_ngram\",\"min_gram\":1,\"max_gram\":20}},\"analyzer\":{\"autocomplete\":{\"type\":\"custom\",\"tokenizer\":\"standard\",\"filter\":[\"lowercase\",\"autocomplete_filter\"]}}}},\"mappings\":{\"properties\":{\"name\":{\"type\":\"text\",\"analyzer\":\"autocomplete\",\"search_analyzer\":\"standard\"}}}}";
    Map valueMap = json.decode(mappingJson);

    String address;
    double lat, long;

   /*final res= await client.search('salons','_doc', elastic.Query.term('_id', [salonname]), source:true);
   for (final sr in res.hits)
     {
       Map <dynamic, dynamic> currDoc=sr.doc;
       address=currDoc['address'];
       //lat=currDoc['location']
     }*/

    await client.updateIndex('services', valueMap);
    final r1= await client.updateDoc('services', '_doc', name.text,
        {//'name': name.text,
          'price': double.parse(price.text),
          'desc': desc.text,
          'available' : available,
          'salon': salonname,
          'owner': email});
    print("ADDED To Elastic Search "+ r1.toString());

  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
        extendBodyBehindAppBar: true,
      appBar: AppBar(
       backgroundColor: Colors.white.withOpacity(0.0),
        actions:[
          FlatButton(onPressed: (){
            //inserting into elastic search
            CollectionReference salonRef = firestoreInstance.collection("Salon").doc(salonname).collection("Services");
            final docRef= salonRef.doc(name.text).set({
              //'name': name.text,
              'price': price.text,
              'available': available,
              'description': desc.text

            }).whenComplete(() => Navigator.pop(context));

            //adding to elasticsearch into an n-gram type index
            //addToElastic().whenComplete(() => Navigator.pop(context));

          },child:Text('Add', style: TextStyle(fontSize: 25.0, color: Colors.white)),)
        ],
      ),
      body:  Stack(
          children: <Widget>[
      new Container(
      decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/5-100.jpg"), fit: BoxFit.fill)),
    )
    ,Column(
        children: [
          SizedBox(height: 110),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: name,
                decoration: InputDecoration(hintText: 'Service Name')
            ),
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: price,
                decoration: InputDecoration(hintText: 'Price'),
                autofocus: true,
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            child:Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width:10,),
                    Text("Currently Available: ",style: TextStyle(fontSize: 17.0), ),
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor:Color(0xff253976),
                      value:this.available,
                      onChanged: (bool value){
                        setState((){
                          this.available=value;
                        });
                      },
                    )
                  ],
                )
              ],
            )
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
              controller: desc,
              decoration: InputDecoration(hintText:'Description'),
              autofocus: true
            ),
          ),

        ],
      ),
    ]));
  }


}