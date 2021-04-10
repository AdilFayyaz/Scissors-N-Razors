import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final firestoreInstance = FirebaseFirestore.instance;
class addSalonOwner extends StatelessWidget{

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cnic = TextEditingController();
  TextEditingController contact_num = TextEditingController();

  CollectionReference salonRef = firestoreInstance.collection("Salon_Owner");


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        actions:[
          FlatButton(onPressed: (){
            salonRef.doc(email.text).set({
              'First_Name': fname.text,
              'Last_Name': lname.text,
              'Email': email.text,
              'Password': password.text,
              'CNIC': cnic.text,
              'Contact_Number': contact_num.text
            }).whenComplete(() => Navigator.pop(context));
          },child:Text('Save'))
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: fname,
                decoration: InputDecoration(hintText: 'First Name')
            ),
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: lname,
                decoration: InputDecoration(hintText: 'Last Name')
            ),
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: email,
                decoration: InputDecoration(hintText: 'Email')
            ),
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
              controller: password,
              decoration: InputDecoration(hintText: 'Password'),
              autofocus: false,
              obscureText: true,
            ),
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: cnic,
                decoration: InputDecoration(hintText: 'CNIC')
            ),
          ),
          Container(
            decoration: BoxDecoration(border:Border.all()),
            child: TextField(
                controller: contact_num,
                decoration: InputDecoration(hintText: 'Contact No (03**-*******)')
            ),
          ),
        ],
      ),
    );
  }
}