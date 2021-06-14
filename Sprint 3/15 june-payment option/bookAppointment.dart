import 'addSalon.dart';
import 'ManageServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
import 'alertDialog.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
String   message;
bool advancepayment=false;
bool valid=false;
final firestoreInstance = FirebaseFirestore.instance;
bool validTime=true;


TextEditingController cardname = TextEditingController();
TextEditingController cardnum = TextEditingController();
TextEditingController cardyear = TextEditingController();
TextEditingController cardcode = TextEditingController();
////////////////
void _showDialog(BuildContext context, String service) {
  print("In Dialog");
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Alert!"),
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
////////////////////
Widget buildCreditCard(context){

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:<Widget>[

      SizedBox(height:30),
      Container(
        child: TextField(

          controller: cardname,
          keyboardType: TextInputType.name,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.perm_identity,
                color: Color(0xffb19cd9)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xffb19cd9)),
            ),
            labelStyle: TextStyle(color: Color(0xff421c52)),
            labelText: 'card holder name',
            hintStyle:TextStyle(
                color: Colors.black38
            ),
            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),
      SizedBox(height:30),

      Container(
        child: TextField(
          controller: cardnum,
          keyboardType: TextInputType.number,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.credit_card_rounded,
                color: Color(0xffb19cd9)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xffb19cd9)),
            ),
            labelStyle: TextStyle(color: Color(0xff421c52)),
            labelText: 'Credit Card number',
            hintStyle:TextStyle(
                color: Colors.black38
            ),
            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),
      SizedBox(height:30),
      Container(
        child: TextField(
          controller: cardcode,
          keyboardType: TextInputType.number,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: Color(0xffb19cd9)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xffb19cd9)),
            ),
            labelStyle: TextStyle(color: Color(0xff421c52)),
            labelText: 'Security Code',
            hintStyle:TextStyle(
                color: Colors.black38
            ),
            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),
      SizedBox(height:30),
      Container(
        child: TextField(
          controller: cardyear,
          keyboardType: TextInputType.number,
          style: TextStyle(
              color: Colors.black38
          ),
          decoration: InputDecoration(
            border:InputBorder.none,

            prefixIcon: Icon(
                Icons.calendar_today_rounded,
                color: Color(0xffb19cd9)
            ),
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(color:Color(0xffb19cd9)),
            ),
            labelStyle: TextStyle(color: Color(0xff421c52)),
            labelText: 'Year of expiry',
            hintStyle:TextStyle(
                color: Colors.black38
            ),
            contentPadding: EdgeInsets.only(top:2.5),
          ),
        ),
      ),

///////////////
  Container(
    alignment: Alignment.center,
  padding: EdgeInsets.symmetric(vertical:10.0),
  child:RaisedButton(
  elevation: 5.0,
  onPressed: () async {
    if(cardnum.text.isEmpty ||cardname.text.isEmpty||cardcode.text.isEmpty||cardyear.text.isEmpty ){
      message="Payment Unsuccessful: please fill all fields";
      _showDialog(context, message);
    }
    else{
    message="Payment Successful";
    _showDialog(context, message);
    advancepayment=true;
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
  'Pay!',
  style: TextStyle(
  color:Color(0xffcdb3d4),
  letterSpacing: 1.5,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,


  ),
  ),

  ),

  ),
    ],
  );

}
//////////////////
class TabWidget extends StatelessWidget {
  const TabWidget({
    Key key,
    @required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) => ListView(
    //padding: EdgeInsets.all(16),
    controller: scrollController,
    children: [
      Text(
        'Want to pay in advance?',
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),

          buildCreditCard(context)


    ],
  );
}
/////////////////
class bookAppointment extends StatefulWidget{
  @override
  final salonname;
  final email;

  bookAppointment(this.cart, this.salonname, this.email);
  var cart=<Map>[];
  BookAppointment createState() => BookAppointment(this.cart, this.salonname, this.email);
}
class BookAppointment extends State<bookAppointment> {
  final panelController = PanelController();
  final double tabBarHeight = 100;

  DateTime _today=DateTime.now();
  DateTime _today2=DateTime.now();
  String month=DateFormat.yMMM().format(DateTime.now());
  DateTime apptDate=DateTime.now();
  String msg="";
  int _counter = 0;
  var cart = <Map>[];
  final salonname;
  final email;
  BookAppointment(this.cart,this.salonname, this.email);

  double _height;
  double _width;

  double dw, dh;
  String _setTime;

  String _hour, _minute, _time;

  String dateTime;
  String message="";


  TimeOfDay time = TimeOfDay(hour: 00, minute: 00);

  TextEditingController timeController = TextEditingController();

  compareTime() async {

    var result=await firestoreInstance.collection("Salon").doc(salonname).get();
    Timestamp ot=result.data()["opening"];
    Timestamp ct=result.data()["closing"];
    validTime=true;

    DateTime od=ot.toDate();
    DateTime cd=ct.toDate();
    print(od);
    if (time.hour < od.hour || (time.hour==od.hour && time.minute < od.minute))
    {
      print("early");
      message="Salon does not open by this time!";
      validTime=false;

    }
    else if (time.hour > cd.hour || (time.hour==cd.hour && time.minute > cd.minute))
    {
      validTime=false;
      message="Salon is closed by this time!";
      print("late");
    }



  }
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked != null)
      setState(() {
        time = picked;
        _hour = time.hour.toString();
        _minute = time.minute.toString();
        _time = _hour + ' : ' + _minute;
        timeController.text = _time;
      });}



  getEvents() async {
    var result= await firestoreInstance.collection("Appointments").where("customer", isEqualTo: this.email).get();

    setState(() {
    List<DateTime> dates=[null];
    print(result.size);
    print(result.toString());
    result.docs.forEach((res) {
      Timestamp t=res.data()["datetime"];
      print(t);
      DateTime temp= t.toDate();
      DateTime d= new DateTime(temp.year, temp.month, temp.day);
      print(d);
      dates.add(d);
    });
    for (int i=0; i<dates.length; i++){
      if (dates.elementAt(i)!=null) {
        _markedDateMap.add(
            dates.elementAt(i),
            new Event(
                date: dates.elementAt(i),
                title: "Appointment",
                icon: _apptIcon
            )

        );
      }
    }
    });
  }

  CalendarCarousel _calendarCarouselNoHeader;
  static Widget _apptIcon=new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>();
  @override
  void initState() {

    getEvents();

    _markedDateMap.add(
        new DateTime(2020, 2, 25),
        new Event(
          date: new DateTime(2020, 2, 25),
          title: 'Event 5',
          icon: _apptIcon,
        ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.purple,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _today2 = date);
        events.forEach((event) => print(event.title));
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _today2,
      targetDateTime: apptDate,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
      CircleBorder(side: BorderSide(color: Colors.lightBlueAccent)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.white,
      ),

      todayButtonColor: Colors.purple,
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
      ),
      minSelectedDate: _today.subtract(Duration(days: 360)),
      maxSelectedDate: _today2.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          apptDate = date;
          month = DateFormat.yMMM().format(apptDate);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );
    return new Scaffold(
        appBar: AppBar(title:Text(('Select A Date')),),
        body:SingleChildScrollView(
    // SlidingUpPanel(
    //         controller: panelController,
    //        // maxHeight: MediaQuery.of(context).size.height - tabBarHeight,
    //         panelBuilder: (scrollController) => buildSlidingPanel(
    //           scrollController: scrollController,
    //           //panelController: panelController,
    //         ),

            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //custom icon


              Container(
                margin: EdgeInsets.only(
                  top: 30.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          month,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        )),
                    FlatButton(
                      child: Text('PREV'),
                      onPressed: () {
                        setState(() {
                          apptDate = DateTime(
                              apptDate.year, apptDate.month - 1);
                          month =
                              DateFormat.yMMM().format(apptDate);
                        });
                      },
                    ),
                    FlatButton(
                      child: Text('NEXT'),
                      onPressed: () {
                        setState(() {
                          apptDate = DateTime(
                              apptDate.year, apptDate.month + 1);
                          month =
                              DateFormat.yMMM().format(apptDate);
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarouselNoHeader,
              ),
              Container(
                // width: _width,
                // height: _height,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Choose Time',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0),
                        ),
                        InkWell(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            width: 250,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                              onSaved: (String val) {
                                _setTime = val;
                              },
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: timeController,
                              decoration: InputDecoration(
                                  disabledBorder:
                                  UnderlineInputBorder(borderSide: BorderSide.none),
                                  // labelText: 'Time',
                                  contentPadding: EdgeInsets.only(top:1, bottom:13)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                //margin: EdgeInsets.all(25),
                child: FlatButton(
                  child: Text('Book', style: TextStyle(fontSize: 20.0),),
                  color: Colors.deepPurpleAccent,
                  textColor: Colors.white,
                  onPressed: () async{
                    var xyz=await compareTime();
                    DialogBox dialog = new DialogBox();
                    if (validTime==false)
                      dialog.showDialogInfo(context,"Alert!", message);
                    else {
                      CollectionReference aptRef = firestoreInstance.collection(
                          "Appointments");
                      List<String> items = [];
                      int price = 0;
                      for (int i = 0; i < cart.length; i++) {
                        items.add(cart[i]['Service']);
                        price += int.parse(cart[i]['Price']);
                      }


                      final docRef = aptRef.add({
                        //'name': name.text,
                        'datetime': new DateTime(_today2.year, _today2.month,
                            _today2.day, time.hour, time.minute),
                        'customer': email,
                        'services': items,
                        'total': price,
                        'salon': salonname,
                        'advancePayment':advancepayment,


                      }).whenComplete(() => Navigator.pop(context));
                      advancepayment=false;
                    }

                  },
                ),
              ),//

                SlidingUpPanel(controller: panelController,
                    borderRadius:BorderRadius.circular(50),
                    color: Colors.deepPurpleAccent,


                    // maxHeight: MediaQuery.of(context).size.height - tabBarHeight,
                  panelBuilder: (scrollController) => buildSlidingPanel(
                    scrollController: scrollController,
                    //panelController: panelController,
                  ),
                ),

            ],
          ),


        )


    );
  }


  ////////////////////////////////
  Widget buildSlidingPanel({
   // @required PanelController panelController,
    @required ScrollController scrollController,
  }) =>TabWidget(scrollController: scrollController);




}
