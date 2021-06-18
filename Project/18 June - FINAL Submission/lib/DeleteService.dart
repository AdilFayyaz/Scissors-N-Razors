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

class DelService extends StatefulWidget{
  final String email;
  final String salonname;
  DelService(this.email, this.salonname);
  @override
  delService createState() => delService(this.email, this.salonname);
}

class delService extends State<DelService>{
  final String email;
  final String salonname;
  String Id;
  delService(this.email, this.salonname);

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
          'price': price.text,
          'desc': desc.text,
          'available' : available,
          'salon': salonname,
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
            String p,d;
            bool a;
            CollectionReference salonRef = firestoreInstance.collection("Salon").doc(salonname).collection("Services");

            final docRef = salonRef.doc(name.text).delete().whenComplete(() => Navigator.pop(context));



            //adding to elasticsearch into an n-gram type index
            //addToElastic().whenComplete(() => Navigator.pop(context));

          },child:Text('Delete'))
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: name,
                decoration: InputDecoration(hintText: 'Service Name')
            ),
          ),
        ],
      ),
    );
  }


}