

//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final firestoreInstance = FirebaseFirestore.instance;


TextEditingController fname = TextEditingController();
TextEditingController lname = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController location = TextEditingController();
TextEditingController contact_num = TextEditingController();

CollectionReference customerRef = firestoreInstance.collection("Customers");
String message;
bool passValid=true;

void _showDialog(BuildContext context, String service) {
  print("In Dialog");
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Oops!"),
        content: new Text(service),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            color: Colors.deepPurple[200],
            child: new Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

        ],
      );
    },
  );
}

Widget createSignupButton(context){
  return Container(
    padding: EdgeInsets.symmetric(vertical:10.0),
    child:RaisedButton(
      elevation: 5.0,
      onPressed: () async {
        addCustomer c= new addCustomer();
        var xyz=await c.checkPassword(password.text, email.text);
        if (passValid==false) {
          _showDialog(context, message);
          print("was false");
        }
        else {
          customerRef.doc(email.text).set({
            'First_Name': fname.text,
            'Last_Name': lname.text,
            //'Email': email.text,
            'Password': password.text,
            'Location': location.text,
            'Contact_Number': contact_num.text
          }).whenComplete(() => Navigator.pop(context));
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),

      ),
      color: Colors.white,
      padding:EdgeInsets.all(15.0),
      splashColor: Color(0xffe7b7cb),
      highlightElevation: 60.0,
      child: Text(
        'SIGN UP!',
        style: TextStyle(
          color: Color(0xff8c4b83),
          letterSpacing: 1.5,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,


        ),
      ),

    ),

  );
}
Widget buildEmail(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:<Widget>[


      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius:6,
                  offset: Offset(0,2)
              )
            ]
        ),
        height:40,
        child: TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.email,
                color: Color(0xff5c3248)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xff5c3248)),
            ),
            labelStyle: TextStyle(color:  Color(0xff8c4b83)),
            labelText: 'Email',
            hintStyle:TextStyle(
                color: Colors.black38
            ),
            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),

    ],
  );

}
Widget buildFirstNameField(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:<Widget>[

      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius:6,
                  offset: Offset(0,2)
              )
            ]
        ),
        height:40,
        child: TextField(
          controller: fname,
          obscureText: false,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.account_circle_outlined,
                color: Color(0xff5c3248)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xff5c3248)),
            ),
            labelStyle: TextStyle(color:  Color(0xff8c4b83)),
            labelText: 'First Name',
            hintStyle:TextStyle(
                color: Colors.black38
            ),
            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),

    ],
  );

}
Widget buildLastNameField(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:<Widget>[

      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius:6,
                  offset: Offset(0,2)
              )
            ]
        ),
        height:40,
        child: TextField(
          controller: lname,
          obscureText: false,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.account_circle,
                color: Color(0xff5c3248)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xff5c3248)),
            ),
            labelStyle: TextStyle(color:  Color(0xff8c4b83)),
            labelText: 'Last Name',
            hintStyle:TextStyle(
                color: Colors.black38
            ),
            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),

    ],
  );

}
Widget buildPassword(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:<Widget>[

      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius:6,
                  offset: Offset(0,2)
              )
            ]
        ),
        height:40,
        child: TextField(
          controller: password,
          obscureText: true,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.lock,
                color: Color(0xff5c3248)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xff5c3248)),
            ),
            labelStyle: TextStyle(color:  Color(0xff8c4b83)),
            labelText: 'Password',
            hintStyle:TextStyle(
                color: Colors.black38
            ),
            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),

    ],
  );

}
Widget buildLocation(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:<Widget>[

      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius:6,
                  offset: Offset(0,2)
              )
            ]
        ),
        height:40,
        child: TextField(
          controller: location,
          keyboardType: TextInputType.streetAddress,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.location_on_sharp,
                color: Color(0xff5c3248)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xff5c3248)),
            ),
            labelStyle: TextStyle(color:  Color(0xff8c4b83)),
            //controller: address,
            labelText: 'Location',

            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),
      SizedBox(height:2),
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius:6,
                  offset: Offset(0,2)
              )
            ]
        ),
        height:30,

        child: TextField(
          keyboardType: TextInputType.number,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.map_sharp,
                color: Color(0xff5c3248)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xff5c3248)),
            ),
            labelStyle: TextStyle(color:  Color(0xff8c4b83)),
            //controller: longitude,
            labelText: 'Longitude',

            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),
      SizedBox(height:2),
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius:6,
                  offset: Offset(0,2)
              )
            ]
        ),
        height:30,

        child: TextField(
          keyboardType: TextInputType.number,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.map_sharp,
                color: Color(0xff5c3248)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xff5c3248)),
            ),
            labelStyle: TextStyle(color:  Color(0xff8c4b83)),
            //controller: latitude,
            labelText: 'Latitude',

            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),

      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical:10.0),
        child:RaisedButton(
          elevation: 5.0,
          onPressed: () {
            //getLoc();
            //  longitude.text=_currentPosition.longitude.toString();
            // latitude.text=_currentPosition.latitude.toString();


          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),

          ),
          color: Colors.white,
          padding:EdgeInsets.all(15.0),
          splashColor: Color(0xffe7b7cb),
          highlightElevation: 60.0,
          child: Text(
            'Get Current Location Instead',
            style: TextStyle(
              color:Color(0xffe7b7cb),
              letterSpacing: 1.5,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,


            ),
          ),

        ),

        ////////////////////

      ),
    ],
  );

}
Widget buildContactnum(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:<Widget>[

      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  blurRadius:6,
                  offset: Offset(0,2)
              )
            ]
        ),
        height:40,
        child: TextField(
          controller: contact_num,
          keyboardType: TextInputType.number,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.local_phone_outlined,
                color: Color(0xff5c3248)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xff5c3248)),
            ),
            labelStyle: TextStyle(color:  Color(0xff8c4b83)),
            labelText: 'Contact Number',
            hintStyle:TextStyle(
                color: Colors.black38
            ),
            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),

    ],
  );

}

class addCustomer extends StatelessWidget{
  void checkPassword(String password, String email) async {
    int issues=0;
    // setState((){
    message="";
    passValid=true; //initially consider all valid
    //});
    if (password==null || email==null){
      // setState((){
      message="Invalid Password or Email";
      passValid=false; //initially consider all valid
      //});
    }
    if (((password.isEmpty) || email.isEmpty )){//Empty Password
      // setState((){
      message+="Invalid Password or Email";
      passValid=false;
      //  });
    }
    else {
      if (!((password.length >= 4))) { //password max length=20 and min length=4

        if (issues==0){
          message="Invalid Password: Weak";
        }
        else
          message += " , Weak Password";
        passValid = false;
        issues++;

      }



      int Integer_count = 0;

      for (int i = 0; i < 10; i++) {
        String num = i.toString();
        if (password.contains(num)) {
          Integer_count++;
        }
      }
      if (Integer_count == 0) { //no digits were present
        if (issues==0)
          message = "Invalid Password:No Digits Present";
        else
          message+=", No Digits Present";
        issues++;
        passValid = false;
        //});
      }

      int count = 0;
      List<String> caps=['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];

      for (int i = 0; i < 26; i++) { //check that capital letters are present in the password{

        if (password.contains(caps.elementAt(i))) {
          count = 1;
        }
      }
      if (count == 0) { //no Caps present
        if (issues==0)
          message="Invalid Password: No Capital Letters were present";
        else
          message +=", No Capital Letters Present";
        issues++;
        passValid = false;
        //});
      }
      if (!email.contains("@")) { //check for correct email format
        if (issues==0)
          message = "Invalid Email";
        else
          message+=", Invalid Email";
        passValid = false;
        issues++;
      }
      var document= await firestoreInstance.collection("Customers").doc(email).get();
      if (document.exists){ //this email has already signed up
          if(issues==0)
            message="Invalid Email: This Email Already Exists";
          else
            message+=" , Invalid Email: This Email Already Exists";
          issues++;
          passValid=false;
          print("Customer exists"+ passValid.toString());
      }

    }

  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: new Stack(fit: StackFit.expand, children: <Widget>[

          new Container(
            decoration: BoxDecoration(
              /* gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x60b19cd9),
                      Color(0x99b19cd9),
                      Color(0xCCb19cd9),
                      Color(0xff5c3248),
                    ]
                )*/
              image: DecorationImage(
                image:AssetImage("assets/images/signup-100.jpg"),
                fit:BoxFit.cover,
              ),
            ),
            width: 250,
            height: 250,

          ),
          new Theme(
            data: new ThemeData(
                brightness: Brightness.dark,
                inputDecorationTheme: new InputDecorationTheme(
                  // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                  labelStyle:
                  new TextStyle(color: Colors.tealAccent, fontSize: 25.0),
                )),

            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal:40,
                vertical: 30,
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[


                  SizedBox(height:60),
                  Text(
                      'Customer\n  Sign Up',
                      style:TextStyle(
                          color: Color(0xff8c4b83),
                          fontSize: 40,
                          fontWeight:FontWeight.bold
                      )
                  ),
                  SizedBox(height:30),
                  buildFirstNameField(),
                  SizedBox(height:10),
                  buildLastNameField(),
                  SizedBox(height:10),

                  buildContactnum(),
                  SizedBox(height:10),
                  buildEmail(),
                  SizedBox(height:10),
                  buildPassword(),
                  SizedBox(height:20),
                  createSignupButton(context),




                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }


}
