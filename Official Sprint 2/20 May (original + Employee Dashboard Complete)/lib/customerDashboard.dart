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
import 'elasticsearchdelegate.dart';
import 'getInformation.dart';
import 'viewSalon.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'customerNavBar.dart';

class SalonInfo{
  String name;
  GeoPoint location;
  int visitCount;

  SalonInfo(String n, GeoPoint location, int v) {
    name=n;
    this.location=location;
    visitCount=v;
  }
}


final firestoreInstance = FirebaseFirestore.instance;
List<SalonInfo> SalonNames = [];
List<SalonInfo> topTrending=[];
List<SalonInfo> closest=[];
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
Future<int> getSalonNames() async {
  //at this point also get Salon tap count and Salon locations
  await firestoreInstance.collection("Salon").get().then((querySnapshot){
    final allData =  querySnapshot.docs.map((doc) => new SalonInfo(doc.id.toString(), doc.data()["location"], doc.data()["visitCount"])).toList();
    SalonNames = allData;

    return 1;
  });
}
Future<int> getSalonNames2() async {
  //at this point also get Salon tap count and Salon locations
  await firestoreInstance.collection("Salon").get().then((querySnapshot){
    final allData =  querySnapshot.docs.map((doc) => new SalonInfo(doc.id.toString(), doc.data()["location"], doc.data()["visitCount"])).toList();
    closest = allData;

    return 1;
  });
}
CollectionReference _collectionRef = FirebaseFirestore.instance.collection("Salon");
GeoPoint loc;
class customerDashboard extends StatefulWidget{
  final String email;
  customerDashboard(this.email);
  @override
  _customerDashboard createState() => _customerDashboard(this.email);
}
class _customerDashboard extends State<customerDashboard> {

  @override
  Future<void> initState() {

    print("INTIALIZING**********************************************************");
    //var x = getSalonNames();
    // SalonNames = [];
    // topTrending=[];
    // closest=[];
    firestoreInstance.collection("Salon").get().then((querySnapshot){
      final allData =  querySnapshot.docs.map((doc) => new SalonInfo(doc.id.toString(), doc.data()["location"], doc.data()["visitCount"])).toList();
      SalonNames = allData;
      topTrending=allData;
    });
    var y=getSalonNames2();

    for (int i=0; i<SalonNames.length-1; i++){
      for (int i=0; i<SalonNames.length-1; i++){
        if (topTrending[i].visitCount<topTrending[i+1].visitCount){
          SalonInfo temp=topTrending[i];
          topTrending[i]=topTrending[i+1];
          topTrending[i+1]=temp;
        }
      }
    }
    if (topTrending.length>0) {
      print(topTrending[0].name + topTrending[0].visitCount.toString());
      print(topTrending[1].name + topTrending[1].visitCount.toString());
    }
    Geodesy geodesy = Geodesy();

    getLoc();
    LatLng current;
    if (_currentPosition!=null) {
      loc = new GeoPoint(_currentPosition.latitude, _currentPosition.longitude);
      current = LatLng(
          _currentPosition.latitude, _currentPosition.longitude);
      print(_currentPosition.latitude.toString() + "," +
          _currentPosition.longitude.toString());
    }


    for (int i=0; i<SalonNames.length-1; i++){ //sorting based on distance from current location
      for (int i=0; i<SalonNames.length-1; i++){
        LatLng loci=LatLng(closest[i].location.latitude, closest[i].location.longitude);
        LatLng loci1=LatLng(closest[i+1].location.latitude, closest[i+1].location.longitude);
        num disi = geodesy.distanceBetweenTwoGeoPoints(current, loci);
        num disi1=geodesy.distanceBetweenTwoGeoPoints(current, loci1);
       // print("Distance of "+closest[i].name+" is "+disi.toString());
        if (disi>disi1){
          SalonInfo temp=closest[i];
          closest[i]=closest[i+1];
          closest[i+1]=temp;
        }
      }

    }

    if (topTrending.length>0) {
      print(topTrending[0].name + topTrending[0].visitCount.toString());
      print(topTrending[1].name + topTrending[1].visitCount.toString());
    }




    super.initState();


  }
  final String email;
  _customerDashboard(this.email);
  String salonname;
  TextEditingController name = TextEditingController();


  final AppBarController appBarController = AppBarController();

  Future<void> _showSearch() async {
    await showSearch(
      context: context,
      delegate: ElasticSearchDelegate(email),
      query: "",
    );
  }


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
          title: Text("Search All Salons"),
          actions: <Widget>[
            InkWell(
              child: Icon(
                Icons.search,
              ),
              onTap:  //This is where You change to SEARCH MODE. To hide, just
                //add FALSE as value on the stream
                //appBarController.stream.add(true);
                // ignore: unnecessary_statements
                _showSearch,
            ),
          ],
        ),
      ),
        body: Column(

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
          Container(
            padding: const EdgeInsets.symmetric(vertical:80),
            child: Text(
              'Top Trending',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: Container(
              height:130,
              child: ListView.builder(

                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                //itemCount: SalonNames.length,
                itemCount: SalonNames.length==0?0:5, //show top 6 salons
                padding: EdgeInsets.only(bottom: 70.0),

                itemBuilder: (BuildContext context, int index) =>
                Container(
                  //minWeight: 1000, // Height not changing :((
                  height:130,
                  width: 130,
                    child:Card(
                      //child: Center(child: Text(SalonNames[index])),

                        child: InkWell(
                          splashColor: Colors.deepPurple[50],
                          onTap: () async {
                            var docRef=await firestoreInstance.collection("Salon").doc(topTrending[index].name).get();
                            Map<String, dynamic> data = docRef.data();
                            int visitCount=data['visitCount'];
                            print("Count is "+visitCount.toString()+" of "+topTrending[index].name);
                            CollectionReference salonRef = firestoreInstance.collection("Salon"); //Salon was clicked, update count
                            int newVisitCount=visitCount+1;
                            print("New visit count is now "+newVisitCount.toString());
                            final docRef2= await salonRef.doc(topTrending[index].name).update({
                                'visitCount': newVisitCount
                              }).whenComplete(() => Navigator.push(context,MaterialPageRoute(builder: (_)=>viewSalon(topTrending[index].name, this.email))));
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
                                 new Text(topTrending[index].name,
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
          ),
            Container(
              padding: const EdgeInsets.only(top:10),
              child: Text(
                'Closest To You',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

            Expanded(
              child: Container(
                height:130,
                child: ListView.builder(

                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  //itemCount: SalonNames.length,
                  itemCount: SalonNames.length==0?0:5,
                  padding: EdgeInsets.symmetric(vertical: 35.0),

                  itemBuilder: (BuildContext context, int index) =>
                      Container(
                        //minWeight: 1000, // Height not changing :((
                        height:130,
                        width: 130,
                        child:Card(
                          //child: Center(child: Text(SalonNames[index])),

                          child: InkWell(
                              splashColor: Colors.deepPurple[50],
                              onTap: () async {
                                var docRef=await firestoreInstance.collection("Salon").doc(closest[index].name).get();
                                Map<String, dynamic> data = docRef.data();
                                int visitCount=data['visitCount'];
                                print("Count is "+visitCount.toString()+" of "+closest[index].name);
                                CollectionReference salonRef = firestoreInstance.collection("Salon"); //Salon was clicked, update count
                                int newVisitCount=visitCount+1;
                                print("New visit count is now "+newVisitCount.toString());
                                final docRef2= await salonRef.doc(closest[index].name).update({
                                  'visitCount': newVisitCount
                                }).whenComplete(() => Navigator.push(context,MaterialPageRoute(builder: (_)=>viewSalon(closest[index].name, this.email))));
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
                                    new Text(closest[index].name,
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

