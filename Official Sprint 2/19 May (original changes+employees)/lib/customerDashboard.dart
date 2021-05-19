import 'package:flutter/rendering.dart';

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
import 'customerNavBar.dart';


final firestoreInstance = FirebaseFirestore.instance;
List<String> SalonNames = [];
Future<int> getSalonNames() async {
  firestoreInstance.collection("Salon").get().then((querySnapshot){
    final allData = querySnapshot.docs.map((doc) => doc.id).toList();
    SalonNames = allData;
    return 1;
  });
}
CollectionReference _collectionRef = FirebaseFirestore.instance.collection("Salon");
class customerDashboard extends StatefulWidget{
  final String email;
  customerDashboard(this.email);
  @override
  _customerDashboard createState() => _customerDashboard(this.email);
}
class _customerDashboard extends State<customerDashboard> {
  @override
  void initState(){
    super.initState();
    var x = getSalonNames();
  }
  //var x =getSalonNames();
  final String email;
  _customerDashboard(this.email);
  String salonname;
  TextEditingController name = TextEditingController();


  final AppBarController appBarController = AppBarController();

List<String> list_names = [];
    @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return Scaffold(
      drawer: NavDrawer(email),
      appBar:

      SearchAppBar(
        primary: Colors.pink[400],
        appBarController: appBarController,
        // You could load the bar with search already active
        autoSelected: false,
        searchHint: "Salon Name...",
        mainTextColor: Colors.white,
        onChange: (String value) {
          //Your function to filter list. It should interact with
          //the Stream that generate the final list
        },
        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          backgroundColor: Colors.redAccent[700],
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
          Container(
            padding: const EdgeInsets.all(8.0),
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.redAccent[700],
              width: 2),
                borderRadius: BorderRadius.circular(10),
                //color: Colors.yellow[800],

            ),
            child: Text(
              'Welcome Back to Scissors N Razors',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),

            ),
        Expanded(

          child: ListView.builder(

            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: SalonNames.length,
            padding: EdgeInsets.symmetric(vertical: 25.0),
            itemBuilder: (BuildContext context, int index) =>
            Container(
              //minWeight: 1000, // Height not changing :((
              width: 200,
                child:Card(
                  //child: Center(child: Text(SalonNames[index])),

                    child: InkWell(
                      splashColor: Colors.deepPurple[50],
                      onTap: () async {
                        Navigator.push(context,MaterialPageRoute(builder: (_)=>viewSalon(SalonNames[index], this.email)));
                      },
                      child: //Center(child: Text(SalonNames[index])) ,
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/menuNavBar3.jpeg"),
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                             new Text(SalonNames[index],
                                 style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.8))//Text(SalonNames[index]),
                        ],
                      ),)
                    ),

                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,

                  color: Colors.pink[100],
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

        Expanded(
          child:
          Container(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
              child: Card(


                  child: InkWell(
                      splashColor: Colors.deepPurple[300],
                      onTap: () {
                       // Navigator.push(context,MaterialPageRoute(builder: (_)=>viewSalon(SalonNames[index], this.email)));
                      },
                      child: //Center(child: Text(SalonNames[index])) ,
                      Container(

                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/ViewAppts.jpg"),
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("View Appointments",
                                style: TextStyle(
                                color: Colors.grey[800],
                                //fontWeight: FontWeight.bold,
                                fontSize: 30)),

                          ],
                        ),)
                  ),

                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,

                  color: Colors.yellow[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  elevation: 10,
                  margin: EdgeInsets.all(15)
              ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(

              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              padding: EdgeInsets.symmetric(vertical: 0.0),
              itemBuilder: (BuildContext context, int index) =>
                  Container(
                    //minWeight: 1000, // Height not changing :((
                    width: 200,
                    child:Card(
                      //child: Center(child: Text(SalonNames[index])),

                      child: InkWell(
                          splashColor: Colors.deepPurple[50],
                          onTap: () {
                           // Navigator.push(context,MaterialPageRoute(builder: (_)=>viewSalon(SalonNames[index], this.email)));
                          },
                          child: //Center(child: Text(SalonNames[index])) ,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/feedback.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                if (index == 0)
                                  new Text("Feedback",
                                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.8))
                                else
                                  new Text("Deals",
                                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.8))
                              ],
                            ),)
                      ),

                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,

                      color: Colors.pink[100],
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

