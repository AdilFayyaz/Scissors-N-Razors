import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customerRating.dart';
final firestoreInstance = FirebaseFirestore.instance;
List<String> Appointments=[];
List<String> Allappointments=[];
List<String> ApptIDs = [];
class viewCustomerAppointments extends StatefulWidget {
  final String email;
  viewCustomerAppointments(this.email);
  @override
  _viewCustomerAppointments createState() => _viewCustomerAppointments(email);
}

  class _viewCustomerAppointments extends State<viewCustomerAppointments>{

    final String email;
    _viewCustomerAppointments(this.email);

    @override
    void initState() {
      Appointments.clear();
      Allappointments.clear();
      ApptIDs.clear();
      getAllCustomerAppointments(email);
      super.initState();
    }

  Future<int> getAllCustomerAppointments(custEmail) async {
    firestoreInstance.collection("Appointments").get().then((querySnapshot) {
      setState(() {
        DateTime today=DateTime.now();
        querySnapshot.docs.forEach((res) {
          Timestamp t = res.data()["datetime"];
          DateTime temp = t.toDate();
          DateTime d = new DateTime(temp.year, temp.month, temp.day);
          if ((d.year > today.year) ||( d.year==today.year && d.month>today.month) || ( d.year==today.year && d.month==today.month && d.day>today.day) ){
          }
          else{
            Allappointments.add((res.id+" "+
                res.data()['salon'].toString() + " " +
                res.data()['customer'] + " " +
                res.data()['datetime'].toDate().toString() + " Services booked: " +
                res.data()['services'].toString()));
          }

        });

        if (Appointments.isEmpty) {
          for (int i = 0; i < Allappointments.length; i++) {
            String id = Allappointments[i].split(" ")[0].toString();

            if (Allappointments[i].split(" ")[2].toString() == custEmail) {
              ApptIDs.add(id);
              Appointments.add(Allappointments[i]);
            }
          }
        }
      });
      return 1;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.white.withOpacity(0.0),title: Text(('Appointments')),

    ),
    body:Stack(
        children: <Widget>[
    new Container(
    decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/9-100.jpg"), fit: BoxFit.fill)),
    )
    ,  SingleChildScrollView( child: Center(
    child: Column(
    children: <Widget>[
      SizedBox(width: 400, height: 80,),
      new Container(

          margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
          child:
          Text(
            "Select Appointment to Review",
            style: TextStyle(color:Color(0xff111e4b),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )
      ),
      new Container(
        //color: Colors.grey[100],
        height: 500,
        width: 500,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            border: Border.all(
              color: Colors.grey[100].withOpacity(0.8),
            ),
            color: Colors.grey[100].withOpacity(0.8)
        ),
        child: new Stack(
          children: <Widget>[

            new Positioned(
                child: new Container(
                  margin: EdgeInsets.fromLTRB(10, 60, 10, 0),
                  child: new ListView.builder(

                    itemCount: Appointments.length,
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    itemBuilder: (BuildContext context, int index) =>
                        Container(
                          child: ListTile(
                            leading: const Icon(Icons.rate_review_rounded,
                              color: Color(0xff133579),),
                            title: Text(
                                Appointments[index].split(" ")[1].toString() + " " +
                                    Appointments[index].split(" ")[3].toString() + " " +
                                    Appointments[index].split(" ")[4].toString() + " " +
                                    Appointments[index].split(" ")[5].toString() + " " +
                                    Appointments[index].split(" ")[6].toString() + " " +
                                    Appointments[index].split("booked:")[1].toString()
                            ),
                            onTap: () async{
                              print(ApptIDs[index]);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => customerFeedback(ApptIDs[index])));
                            },
                          ),

                        ),

                  ),
                )
            )
          ],
        ),


      ),

    ])))
   ]) );

  }
  }