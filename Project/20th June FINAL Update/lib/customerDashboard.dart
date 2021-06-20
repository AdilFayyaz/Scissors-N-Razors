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



CollectionReference _collectionRef = FirebaseFirestore.instance.collection("Salon");
GeoPoint loc;
class customerDashboard extends StatefulWidget{
  final String email;
  customerDashboard(this.email);
  @override
  _customerDashboard createState() => _customerDashboard(this.email);
}
class _customerDashboard extends State<customerDashboard> {

  Geodesy geodesy = Geodesy();
  LatLng current;

  getLoc() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print("Not enabled ******************8");
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print("Not permitted *****************");
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    LocationData temp;
    temp = await location.getLocation();

    setState(() { _currentPosition=temp; });
  }
  Future<int> getSalonNames() async {
    //at this point also get Salon tap count and Salon locations
    await firestoreInstance.collection("Salon").get().then((querySnapshot){
      setState(() {

        final allData =  querySnapshot.docs.map((doc) => new SalonInfo(doc.id.toString(), doc.data()["location"], doc.data()["visitCount"])).toList();
        SalonNames = allData;
        topTrending= allData;
        for (int i=0; i<SalonNames.length-1; i++){
          for (int i=0; i<SalonNames.length-1; i++){
            if (topTrending[i].visitCount<topTrending[i+1].visitCount){
              SalonInfo temp=topTrending[i];
              topTrending[i]=topTrending[i+1];
              topTrending[i+1]=temp;
            }
          }
        }
      });

      return 1;
    });
  }
  Future<int> getSalonNames2() async {
    //at this point also get Salon tap count and Salon locations
    await firestoreInstance.collection("Salon").get().then((querySnapshot){
      setState(() {


        final allData =  querySnapshot.docs.map((doc) => new SalonInfo(doc.id.toString(), doc.data()["location"], doc.data()["visitCount"])).toList();
        closest = allData;

        if (_currentPosition!=null) {
          loc = new GeoPoint(_currentPosition.latitude, _currentPosition.longitude);
          current = LatLng(
              _currentPosition.latitude, _currentPosition.longitude);
          print(_currentPosition.latitude.toString() + "," +
              _currentPosition.longitude.toString());
        }
        else{
          print("Couldnt get current location");
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
      });

      return 1;
    });
  }
  @override
  Future<void> initState() {

    print("INTIALIZING**********************************************************");
    getLoc();

    var x=getSalonNames();
    var y=getSalonNames2();
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
        extendBodyBehindAppBar: true,

      drawer: NavDrawer(email),
        appBar: AppBar(backgroundColor: Colors.white.withOpacity(0.0)),
      // appBar:
      //
      // SearchAppBar(
      //   primary: Colors.deepPurple[700],
      //   appBarController: appBarController,
      //   // You could load the bar with search already active
      //   autoSelected: false,
      //   searchHint: "Salon Name...",
      //   mainTextColor: Colors.white,
      //   onChange: (String value) {
      //     //Your function to filter list. It should interact with
      //     //the Stream that generate the final list
      //   },
      //   //Will show when SEARCH MODE wasn't active
      //   mainAppBar: AppBar(
      //     backgroundColor: Color(0xff8b4b81),
      //     elevation: 0.0,
      //     title: new Text(
      //       "Search All Salons",
      //       //style: TextStyle(color: Color()),
      //     ),
      //     actions: <Widget>[
      //       InkWell(
      //         child: Icon(
      //           Icons.search,
      //         ),
      //         onTap:  //This is where You change to SEARCH MODE. To hide, just
      //
      //           _showSearch,
      //       ),
      //     ],
      //   ),
      // ),
        resizeToAvoidBottomInset: false,
        body:

         Container(
         decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/3-100.jpg"),
              fit: BoxFit.cover,
            ),
         ),
          child: Column(

          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 100.0),
          Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Color(0xff133579).withOpacity(0.05),
            ),
          ),
          child: TextField(
              // onChanged: _showSearch,
              onTap: _showSearch,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Color(0xff8b4b81),
                ),
                hintText: "Search All Salons",
                hintStyle: TextStyle(color: Color(0xff8b4b81)),
              ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(vertical:40),
            child: Text(
              'Top Trending',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Color(0xff133579)),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: Container(
              // height:130,
              child: ListView.builder(

                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                itemCount: SalonNames.length, //show all salons
                padding: EdgeInsets.only(top: 30.0),

                itemBuilder: (BuildContext context, int index) =>
                Container(
                  //minWeight: 1000, // Height not changing :((
                  height:130,
                  width: 200,
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
                                image: AssetImage("assets/images/menuNavbar3-2-100.jpg"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                      color: Colors.deepPurple.withOpacity(0.2),
                                      child: Text(topTrending[index].name,
                                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.black),)
                                  )],
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
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Color(0xff133579)),
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
                  itemCount: SalonNames.length,
                  padding: EdgeInsets.symmetric(vertical: 20),

                  itemBuilder: (BuildContext context, int index) =>
                      Container(
                        //minWeight: 1000, // Height not changing :((
                        height:130,
                        width: 200,
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
                                    image: AssetImage("assets/images/girl1.jpg"),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                  color: Colors.red.withOpacity(0.2),
                                    child: Text(closest[index].name,
                                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.black),)
                                    )],
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
        )
      ),

      // Adding the drawer here
      //      Stack(
      //   children: <Widget>[Container(
      //       height: 30,
      //       width: 35,
      //       margin: const EdgeInsets.only(
      //         left: 10,
      //         top: 35,
      //         right: 0,
      //         bottom: 0,
      //       ),
      //       decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(10),
      //       color: Colors.white,
      //       boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.5),
      //         spreadRadius: 1,
      //         blurRadius: 1,
      //         offset: Offset(1, 2), // changes position of shadow
      //       ),
      //     ],),),
      //
      //     IconButton(
      //         padding: const EdgeInsets.only(
      //           left: 8,
      //           top: 37,
      //           right: 0,
      //           bottom: 0,
      //           ),
      //         icon: Icon(Icons.menu),
      //         onPressed: () {
      //           // setState(() {
      //           //   Scaffold.of(context).openDrawer();
      //             //NavDrawer(email);
      //           scaffoldKey.currentState.openDrawer();
      //           // });
      //
      //         }),])
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

