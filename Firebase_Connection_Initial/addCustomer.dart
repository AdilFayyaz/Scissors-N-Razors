import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final firestoreInstance = FirebaseFirestore.instance;
class addCustomer extends StatelessWidget{

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController contact_num = TextEditingController();

  CollectionReference customerRef = firestoreInstance.collection("Customers");


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        actions:[
          FlatButton(onPressed: (){
            customerRef.add({
              'First_Name': fname.text,
              'Last_Name': lname.text,
              'Email': email.text,
              'Password': password.text,
              'Location': location.text,
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
                controller: location,
                decoration: InputDecoration(hintText: 'Location')
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