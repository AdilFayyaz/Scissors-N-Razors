import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
final firestoreInstance = FirebaseFirestore.instance;

class customerFeedback extends StatefulWidget {
  final String apptID;
  customerFeedback(this.apptID);
  @override
  _customerFeedback createState() => _customerFeedback(apptID);
}

class _customerFeedback extends State<customerFeedback> {
  final String apptID;
  _customerFeedback(this.apptID);
  String star_rating;

  TextEditingController feedback = TextEditingController();

  Future<int> addFeedback(String feedback, String apptID, String star_rating) async {
    setState(() {
      CollectionReference apptRef = firestoreInstance.collection(
          "Appointments");
      print(feedback);
      print(apptID);

      final docRef = apptRef.doc(apptID).set({
        'feedback': feedback,
        'rating': star_rating,
      }, SetOptions(merge: true)).whenComplete(() => Navigator.of(context).pop());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Feedback Page"),
      //   backgroundColor: Colors.deepPurple,
      // ),
      body: Stack(
          children: <Widget>[
      new Container(
      decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/feedback-100.jpg"), fit: BoxFit.fill)),
    )
    ,SingleChildScrollView(

          child: Center(

          child:

          Column(
          children: <Widget>[

            SizedBox(width: 400, height: 130,),
            new Container(
              //color: Colors.grey[100],
              height: 350,
              width: 500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  border: Border.all(
                    color: Color(0xff133579),
                  ),
                  color: Color(0xff133579).withOpacity(0.6)
              ),
              child: new Stack(
                children: <Widget>[
                  new Positioned(
                    child: new Container(
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                        child: new Stack(
                          children:<Widget> [
                            Container(
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: feedback,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: 'How was your Experience?'
                                ),
                              ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),


            ),
            SizedBox(width: 400, height: 50,),
            Container(
                child: RatingBar(
                  initialRating: 3,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: const Icon(Icons.star_rate ,
                      color:Color(0xff288491),),
                    half: const Icon(Icons.star_half ,
                      color:Color(0xff288491),),
                    empty: const Icon(Icons.star_rate_outlined ,
                      color:Color(0xff288491),),
                  ),
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (rating) {
                    star_rating = rating.toString();
                    print(star_rating);
                  },
                ),
            ),
            SizedBox(width: 400, height: 50,),
            Container(
              child:
              Container(
                  child: RaisedButton(
                      padding:EdgeInsets.symmetric(horizontal: 22.0,vertical: 15.0),
                      splashColor:Color(0xff133579),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),),
                    color: Color(0xff288491), // background
                    textColor: Colors.white, // foreground
                    onPressed: () {
                      addFeedback(feedback.text, apptID, star_rating);
                    },
                    child: Text('Share'),
                  )
              ),

            ),

          ],
        )
      )


      ),
    ],),
    );
  }
}