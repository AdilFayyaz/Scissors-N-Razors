import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final firestoreInstance = FirebaseFirestore.instance;
class getCustomer extends StatelessWidget{
  final String email;
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

class getSalonOwner extends StatelessWidget{
  final String email;
  getSalonOwner(this.email);
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