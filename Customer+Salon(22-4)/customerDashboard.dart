import 'ManageSalon.dart';
import 'addSalon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
import 'viewSalon.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

final firestoreInstance = FirebaseFirestore.instance;
List<String> SalonNames = [];
int getSalonNames(){
  firestoreInstance.collection("Salon").get().then((querySnapshot){
    final allData = querySnapshot.docs.map((doc) => doc.id).toList();
    print("Hereooo");
    SalonNames = allData;
    print("Salons len");
    print(SalonNames.length);
    print(allData);
    return 1;
  });

}
CollectionReference _collectionRef = FirebaseFirestore.instance.collection("Salon");
Future<List<String>> getData() async {
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _collectionRef.get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.id).toList();

  print(allData);
  return allData;
}
class customerDashboard extends StatelessWidget {
  var x =getSalonNames();
  final email;
  customerDashboard(this.email);
  String salonname;
  TextEditingController name = TextEditingController();

  Future<QuerySnapshot> getDocuments() async {
    return await FirebaseFirestore.instance
        .collection('Salon')
        .doc()
        .collection('Services')
        .get();
  }


  final AppBarController appBarController = AppBarController();

List<String> list_names = [];
    @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return Scaffold(
      appBar:SearchAppBar(
        primary: Theme.of(context).primaryColor,
        appBarController: appBarController,
        // You could load the bar with search already active
        autoSelected: true,
        searchHint: "Salon Name...",
        mainTextColor: Colors.white,
        onChange: (String value) {
          //Your function to filter list. It should interact with
          //the Stream that generate the final list
        },
        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Text("Search Nearby Salons"),
          actions: <Widget>[
            InkWell(
              child: Icon(
                Icons.search,
              ),
              onTap: () {
                //This is where You change to SEARCH MODE. To hide, just
                //add FALSE as value on the stream
                appBarController.stream.add(true);
              },
            ),
          ],
        ),
      ),
        body:

        Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

        Text(
          'Customer Dashboard',
          style: TextStyle(fontSize: 18),
        ),

        Expanded(

          child: ListView.builder(

            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: SalonNames.length,
            padding: EdgeInsets.symmetric(vertical: 80.0),
            itemBuilder: (BuildContext context, int index) =>
            Container(
              //minWeight: 1000, // Height not changing :((
              width: 200,

                child:Card(
                  //child: Center(child: Text(SalonNames[index])),

                    child: InkWell(
                      splashColor: Colors.deepPurple[50],
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (_)=>viewSalon(SalonNames[index], this.email)));
                      },
                      child: Center(child: Text(SalonNames[index])) ,
                    ),

                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.deepPurple[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  elevation: 10,
                  margin: EdgeInsets.all(15),
              ),
            ),
          ),
        ),
        Text(
          'Favorites etc info here',
          style: TextStyle(fontSize: 18),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx,int){
              return Card(
                child: ListTile(
                    title: Text('Random Stuff $int'),
                    subtitle: Text('this is a description ')),
              );
            },
          ),
        ),
      ],
    ),
    );
  }

  getSalonsList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) =>
    new ListTile(title: new Text(doc.id),
        subtitle: new Text(doc.id.toString())))
        .toList();
  }
}

// Future<List<DocumentSnapshot>> getProduceID() async{
//   var data = await Firestore.instance.collection('users').document(widget.userId).collection('Products').getDocuments();
//   var productId = data.documents;
//   return productId;
// }

// var products;
// getProduceID().then((data){
// for(int i = 0; i < s.length; i++) {
// products = Firestore.instance.collection('products')
//     .document(data[i]['productID'])
//     .snapshots();
// if (products != null) {
// products.forEach((product) {
// print(product.data.values);
// });
// }
// }
// });