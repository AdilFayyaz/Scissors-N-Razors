import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'customerNavBar.dart';
import 'viewSalon.dart';
import 'viewAppointment.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:flutter/widgets.dart';



final firestoreInstance = FirebaseFirestore.instance;
class getCustomer extends StatelessWidget{
  final email;
  getCustomer(this.email);
  //Use the email to get the document ID. However, maybe Firebase auth can do the trick? check
  //DocumentReference customerRef = firestoreInstance.collection("Customers")..where('email',isEqualTo: email);

  @override
  Widget build(BuildContext context){
    return FutureBuilder<DocumentSnapshot>(
      future: firestoreInstance.collection("Customers").doc(email).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("Full Name: ${data['First_Name']} ${data['Last_Name']}");
        }
        return Text("loading");
      },
    );
  }
}

class getSalonOwner extends StatefulWidget{
 final String email;
 getSalonOwner(this.email);

 @override
  _getSalonOwner createState()=>_getSalonOwner(this.email);
}

class _getSalonOwner extends State<getSalonOwner>{
  final String email;
  _getSalonOwner(this.email);
  //Use the email to get the document ID. However, maybe Firebase auth can do the trick? check
  //DocumentReference customerRef = firestoreInstance.collection("Customers")..where('email',isEqualTo: email);

  @override
  Widget build(BuildContext context){
    return FutureBuilder<DocumentSnapshot>(
      future: firestoreInstance.collection("Salon_Owner").doc(email).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("Full Name: ${data['First_Name']} ${data['Last_Name']}");
        }
        return Text("loading");
      },
    );
  }


}
List<String> SalonNames = [];


CollectionReference _collectionRef = FirebaseFirestore.instance.collection("Salon");
class getSalons extends StatefulWidget{
  final String email;
  getSalons(this.email);
  @override
  _getSalons createState() => _getSalons(this.email);
}
class _getSalons extends State<getSalons> {
  Future<int> getSalonNames(email) async {
    var result = await firestoreInstance
        .collection("Salon")
        .where("owner", isEqualTo: email)
        .get().then((querySnapshot){
      setState(() {

        final allData = querySnapshot.docs.map((doc) => doc.id).toList();

        SalonNames = allData;
      });
      return 1;
    });

  }

  @override
  void initState() {
    super.initState();

    var x = getSalonNames(email);
  }

  //var x =getSalonNames();
  final String email;

  _getSalons(this.email);

  String salonname;
  TextEditingController name = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Salons"),
        backgroundColor: Colors.deepPurple[700],),

      body:
      Column(

        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.all(8.0),
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple[700],
                  width: 2),
              borderRadius: BorderRadius.circular(10),
              //color: Colors.yellow[800],

            ),

            child: Text(
              'My Salons\n   (Click To View Appointments)',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),


          ),
          SizedBox(height: 100),
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
                    child: Card(
                      //child: Center(child: Text(SalonNames[index])),

                      child: InkWell(
                          splashColor: Colors.deepPurple[50],
                          onTap: () {

                            Navigator.push(context, MaterialPageRoute(builder: (
                                _) =>
                                ViewSalonAppointment(SalonNames[index], this.email)));

                          },
                          child: //Center(child: Text(SalonNames[index])) ,
                          Container(

                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(SalonNames[index],
                                    style: DefaultTextStyle
                                        .of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.8))
                                //Text(SalonNames[index]),
                              ],
                            ),)
                      ),

                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,

                      color: Colors.deepPurple[700].withOpacity(0.6),
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

          SizedBox(height: 100),
        ],
      ),
    );
  }
}