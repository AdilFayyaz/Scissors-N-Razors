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
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
bool valid=false;
final firestoreInstance = FirebaseFirestore.instance;


class bookAppointment extends StatefulWidget{
  @override
  final salonname;
  final email;
  bookAppointment(this.cart, this.salonname, this.email);
  var cart=<Map>[];
  BookAppointment createState() => BookAppointment(this.cart, this.salonname, this.email);
}
class BookAppointment extends State<bookAppointment> {
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

  getEvents() async {
    var result= await firestoreInstance.collection("Appointments").where("customer", isEqualTo: this.email).get();
    List<DateTime> dates=[null];
    print(result.size);
    print(result.toString());
    result.docs.forEach((res) {
      Timestamp t=res.data()["date"];
      print(t);
      DateTime d= t.toDate();
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
        body: SingleChildScrollView(
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
                margin: EdgeInsets.all(25),
                child: FlatButton(
                  child: Text('Book', style: TextStyle(fontSize: 20.0),),
                  color: Colors.deepPurpleAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    CollectionReference aptRef = firestoreInstance.collection("Appointments");
                    List<String> items=[];
                    int price=0;
                    for (int i=0; i<cart.length; i++){
                      items.add(cart[i]['Service']);
                      price+=int.parse(cart[i]['Price']);
                    }


                    final docRef= aptRef.add({
                      //'name': name.text,
                      'date': _today2,
                      'customer': email,
                      'services': items,
                      'total': price
                    }).whenComplete(() => Navigator.pop(context));
                    //should next generate invoice
                  },
                ),
              )//
            ],
          ),
        ));
  }
}
