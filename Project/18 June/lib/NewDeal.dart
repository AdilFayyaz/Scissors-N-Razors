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

class NewDeal extends StatefulWidget{
  final String email;
  final String salonname;
  NewDeal(this.email, this.salonname);
  @override
  newDeal createState() => newDeal(this.email, this.salonname);
}

class newDeal extends State<NewDeal>{
  final String email;
  final String salonname;
  String Id;
  newDeal(this.email, this.salonname);

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController desc = TextEditingController();
  bool available;



  static List<String> items=[null];

  @override
  void initState(){
    items=[null];
    super.initState();

  }





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
      appBar: AppBar(
        actions:[
          FlatButton(onPressed: (){
            //inserting into elastic search
            CollectionReference salonRef = firestoreInstance.collection("Salon").doc(salonname).collection("Deals");
            final docRef= salonRef.add({
              //'name': name.text,
              'price': double.parse(price.text),
              'items': items
            }).whenComplete(() => Navigator.pop(context));

            CollectionReference Notif = firestoreInstance.collection("Notifications");
            String msg= salonname+" just added a new deal called "+name.text+" for only "+price.text;
            final doc2Ref=Notif.add({
              'msg':msg

            }).whenComplete(() => Navigator.pop(context));

            //adding to elasticsearch into an n-gram type index
            //addToElastic().whenComplete(() => Navigator.pop(context));

          },child:Text('Add'))
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: name,
                decoration: InputDecoration(hintText: 'Deal Name')
            ),
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: price,
                decoration: InputDecoration(hintText: 'Deal Price')
            ),
          ),
          SizedBox(height:20,),
          Text('Items Included', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16,),),...getItems(),

        ],
      ),
    );
  }

  //add items to deal
List<Widget> getItems(){
    List<Widget> itemsTextFields=[];
    for (int i=0; i<items.length; i++){
      itemsTextFields.add(
        Padding(
          padding:const EdgeInsets.symmetric(vertical:16.0),
            //decoration: BoxDecoration(border:Border.all()),
            child:Row(
              children: [
                Expanded(child:ItemsTextFields(i)),
                SizedBox(width: 16,),
                _addRemoveButton(i==items.length-1, i),
              ],
            )
          )


        );
    }
    return itemsTextFields;
}

Widget _addRemoveButton(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          items.insert(0, null);
        }
        else{
          items.removeAt(index);
        }
        setState(() {});

      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add)?Colors.deepPurple:Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child:Icon((add)?Icons.add: Icons.remove, color:Colors.white,),
      ),
    );
}

}

class ItemsTextFields extends StatefulWidget{
  final int index;
  ItemsTextFields(this.index);
  @override
  itemsTextFields createState()=> itemsTextFields();
}
class itemsTextFields extends State<ItemsTextFields>{
  TextEditingController itemController= new TextEditingController();
  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      itemController.text=newDeal.items[widget.index]??'';
    });
    return TextFormField(
      controller: itemController,
      onChanged: (v)=>newDeal.items[widget.index]=v,
      decoration: InputDecoration(hintText: "Enter Item Name"),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}