import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  String fname = "";
  String lname = "";
  String cnic = "";
  String contact_num = "";
  //Use the email to get the document ID. However, maybe Firebase auth can do the trick? check
  Future<int> getSalonOwnerDetails(String email) async {

      firestoreInstance.collection("Salon_Owner").doc(email).get().then((DocumentSnapshot documentSnapshot) {
        setState(() {
      if (documentSnapshot.exists) {
        fname = documentSnapshot.data()['First_Name'].toString();
        lname = documentSnapshot.data()['Last_Name'].toString();
        contact_num = documentSnapshot.data()['Contact_Number'].toString();
        cnic = documentSnapshot.data()['CNIC'].toString();
        print(fname + lname +  cnic + contact_num + email);
      } else {
        print('Document does not exist on the database');
      }
    });
    });
  }
  @override
  void initState() {
    getSalonOwnerDetails(email);
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(title: Text("Salon Owner Details"),
            backgroundColor: Colors.white.withOpacity(0.0)),

        body: SingleChildScrollView(
                child: Container(
                decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage("assets/images/7-100.jpg"),
                  fit: BoxFit.cover,
                  ),
                  ),
            child: Center(
            child: Column(
            children: <Widget>[
              SizedBox(height: 200,),
              new Container(
              child: Text(
                "First Name: " + fname,
                style: TextStyle(fontSize: 24, color: Color(0xff5c3249))
              ),
            ),
              new Container(
                child: Text(
                    "Last Name: " + lname,
                    style: TextStyle(fontSize: 24, color: Color(0xff5c3249))
                ),
              ),
              new Container(
                child: Text(
                    "CNIC: " + cnic,
                    style: TextStyle(fontSize: 24, color: Color(0xff5c3249))
                ),
              ),
              new Container(
                child: Text(
                    "Contact Number: " + contact_num,
                    style: TextStyle(fontSize: 24, color: Color(0xff5c3249))
                ),
              ),
              SizedBox(height: 420,)
    ])))));
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
        extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("Salons"),
        backgroundColor: Colors.white.withOpacity(0.0)),

      body:
      Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
         // border: Border.all(color: Colors.deepPurple[700], width: 2),
          //borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage("assets/images/9-100.jpg"),
            fit: BoxFit.cover,
          ),
          //color: Colors.yellow[800],

        ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          SizedBox(height: 120),
          Container(
            child: Text(
              'Select a Salon to View Appointments',
              style: TextStyle(fontSize: 18),
            )
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
                    child: Card(

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
                                    style: TextStyle(color: Colors.white, fontSize: 25),
                                    )
                              ],
                            ),)
                      ),

                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,

                      color: Color(0xff8b4b81),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      elevation: 10,
                      //margin: EdgeInsets.all(15),
                      margin: EdgeInsets.fromLTRB(5, 50, 10, 160),
                    ),
                  ),
            ),
          ),

          SizedBox(height: 100),
        ],
      ),
    ));
  }
}