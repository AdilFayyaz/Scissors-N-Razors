import 'package:geodesy/geodesy.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart';
import 'ManageSalon.dart';
import 'package:elastic_client/console_http_transport.dart';
import 'package:elastic_client/elastic_client.dart' as elastic;
import 'addSalon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
import 'viewSalon.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'customerNavBar.dart';
class ElasticSearchDelegate extends SearchDelegate{
  @override
  final email;
  ElasticSearchDelegate(this.email);
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () async {
          query = '';
          await searchElasticServer(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: searchElasticServer(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Center(child: Text("Still searching"));

        return  _displaySalons(snapshot.data) ;
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {

    return FutureBuilder(
      future: searchElasticServer(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Text("Still searching");

        return _displaySalons(snapshot.data) ;
      },
    );
  }

  Widget _displaySalons( List<String> salonList) {

    return ListView.builder(
        itemCount: salonList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(leading: Icon(Icons.face_outlined), title: Text(salonList[index]),
            onTap:() async{
              var docRef=await firestoreInstance.collection("Salon").doc(salonList[index]).get();
              Map<String, dynamic> data = docRef.data();
              int visitCount=data['visitCount'];
              print("Count is "+visitCount.toString()+" of "+salonList[index]);
              CollectionReference salonRef = firestoreInstance.collection("Salon"); //Salon was clicked, update count
              int newVisitCount=visitCount+1;
              print("New visit count is now "+newVisitCount.toString());
              final docRef2= await salonRef.doc(salonList[index]).update({
                 'visitCount': newVisitCount
               }).whenComplete(() => Navigator.push(context,MaterialPageRoute(builder: (_)=>viewSalon(salonList[index], this.email))));
              },
              );
        }
    );
  }

  Future searchElasticServer(searchQuery) async {

    final transport = ConsoleHttpTransport(Uri.parse('http://192.168.10.12:9200/'));
    final client = elastic.Client(transport);
    List<String> salonList = [];

    final searchResult = await client.search(
        'salons', '_doc', elastic.Query.term('name', ['$searchQuery']), source: true);

    print("----------- Found ${searchResult.totalCount} $searchQuery ----------");
    for(final iter in searchResult.hits){
      Map<dynamic, dynamic> currDoc = iter.doc;
      print(currDoc);
      salonList.add(currDoc['name'].toString());
    }

    await transport.close();

    if(searchResult.totalCount <= 0 )
      return null;
    else
      return salonList;
  }
}