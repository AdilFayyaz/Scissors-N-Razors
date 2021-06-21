import 'package:flutter/rendering.dart';
import 'ManageDeals.dart';
import 'addSalon.dart';
import 'ManageServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'employeeNavBar.dart';

bool valid=false;
bool validTime=true;
TextEditingController name = TextEditingController();
final firestoreInstance = FirebaseFirestore.instance;
final Color oddItemColor = Colors.deepPurple.withOpacity(0.05);
final Color evenItemColor = Colors.deepPurple.withOpacity(0.15);


List<String> EmployeeNames = [];
Future<int> getEmployeeNames() async {
  firestoreInstance.collection("Salon").doc(name.text).collection("Employees").get().then((querySnapshot){
    final allData = querySnapshot.docs.map((doc) => doc.data()['name'].toString() + ", Password: " + doc.data()['password'].toString()).toList();
    EmployeeNames = allData;
    return 1;
  });
}


List<String> EmployeeApptsTemp = [];
List<DateTime> EmployeeAppts = [];
Future<bool> getEmployeeAppts(String username) async {
  var result = await firestoreInstance.collection("Appointments").where("employee", isEqualTo: username).get();
  result.docs.forEach((res){
    Timestamp t = res.data()['datetime'];
    DateTime temp = t.toDate();
    DateTime d = new DateTime(temp.year, temp. month, temp.day);
    EmployeeAppts.add(d);
  });
    return true;

}

class employeeDashboard extends StatefulWidget{
  final String username;
  final String salonname;
  employeeDashboard(this.username, this.salonname);
  @override
  EmployeeDashboard createState() => EmployeeDashboard(this.username, this.salonname);

}

class EmployeeDashboard extends State<employeeDashboard> {
  DateTime _today=DateTime.now();
  DateTime _today2=DateTime.now();
  String month=DateFormat.yMMM().format(DateTime.now());
  DateTime apptDate=DateTime.now();


  String msg="";
  int _counter = 0;
  final String username;
  final String salonname;
  EmployeeDashboard(this.username, this.salonname);

  double _height;
  double _width;

  double dw, dh;
  String _setTime;

  String _hour, _minute, _time;

  String dateTime;
  String message="";
  List<String> app=[];
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
  getEvents() async {
    List<String>checkDate=[];
    var result= await firestoreInstance.collection("Appointments").where("employee", isEqualTo: username).get();
    setState(() {
    List<DateTime> dates=[null];
    print(result.size);
    print(result.toString());
    result.docs.forEach((res) {
      Timestamp t=res.data()["datetime"];
      print(t);
      DateTime temp= t.toDate();
      DateTime d= new DateTime(temp.year, temp.month, temp.day);
      print("in events");
      print(d.toString());
      if (!checkDate.contains(d.toString())) {
        dates.add(d);
        checkDate.add(d.toString());
      }
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
      events.forEach((event) {

        Navigator.push(context, MaterialPageRoute(builder: (
            _) =>viewAppointment(this.salonname, this.username,event.date.toString())));

      }

      );
},
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.lightBlueAccent,
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

      todayButtonColor: Colors.pinkAccent,
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
      ),
      minSelectedDate: _today.subtract(Duration(days: 360)),
      maxSelectedDate: _today2.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.indigo,
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
        extendBodyBehindAppBar: true,

        appBar: AppBar(title:Text((username+"'s Appointments")),
            backgroundColor: Colors.white.withOpacity(0.0)),
        drawer: EmpNavDrawer(username,salonname),
        body: Stack(
            children: <Widget>[
        new Container(
        decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/4-100.jpg"), fit: BoxFit.fill)),

    ), SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //custom icon
              SizedBox(width: 400, height: 70,),
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


            ],
          ),
        )
    ]));
  }
}

//////////////////////////////////////////////////////

List<String> Appointments=[];
List<String> Allappointments=[];


Future<int> getSalonAppointment(salonName,date) async{
  // List<String> Appointments=[];

  var result = await firestoreInstance
      .collection("Appointments")
      .where("salon", isEqualTo: salonName)
      .get();

  if (Appointments.isEmpty){
    result.docs.forEach((res) {
      // print(res.data()["total"].toString());
      String temp = "";
      temp = temp + res.data()["customer"];
      temp = temp + " " + res.data()["total"].toString() + " " +
          res.data()["datetime"].toDate().toString().split(" ")[0];


      if (date.split(" ")[0] ==
          res.data()["datetime"].toDate().toString().split(" ")[0]) {
        print("this date");

        Appointments.add(temp);
        print(res.data());

      }
    }
    );
  }

}
class viewAppointment extends StatefulWidget{

  final String salonname;
  final String email;
  final String date;

  viewAppointment(this.salonname, this.email,this.date);
  @override
  _viewAppointment createState() => _viewAppointment(this.salonname, this.email,this.date);
}
/////////////////////

class _viewAppointment extends State<viewAppointment> {
  Future<int> getAllSalonAppointment(salonName,date) async {

    firestoreInstance.collection("Appointments").get().then((querySnapshot){
      setState(() {


      // final allData = querySnapshot.docs.map((doc) => doc.id + " " + doc.data()['salon']).toList();//+" " +doc.data()['customer'].toString()+" "+ doc.data()['datetime'].toDate().toString()+" "+ doc.data()['total'].toString()).toList();
      final allData = querySnapshot.docs.map((doc) => doc.id + " " + doc.data()['salon'].toString()+" "+doc.data()['customer']+" "+doc.data()['datetime'].toDate().toString()+" Services booked: "+doc.data()['services'].toString()).toList();
      Allappointments = allData;
      print("listt");

      print(Allappointments);
      if (Appointments.isEmpty){
        for (int i=0;i<Allappointments.length;i++) {

          print("salon");print(Allappointments[i].split(" ")[1].toString() );
          if (Allappointments[i].split(" ")[1].toString() == salonName) {
            print("datee");
            print(date.split(" ")[0]);
            print(Allappointments[i].split(" ")[3].toString());
            if (date.split(" ")[0] ==
                Allappointments[i].split(" ")[3].toString()) {
              print("this date");
              // if (Appointments.isEmpty){//(!Appointments.contains(temp)) {
              Appointments.add(Allappointments[i]);
              print(Allappointments[i]);
              // }
            }
          }
        }
      }
      });
      return 1;
    });

  }
  @override
  void initState() {
    getAllSalonAppointment(salonname, date);
    for (int i = 0; i < Appointments.length; i++) {
      print(date.split(" ")[0]);
      if (Appointments[i].split(" ")[3] != date.split(" ")[0]) {
        Appointments.removeAt(i);
      }
    }

    super.initState();
  }

  int total = 0;
  final String salonname;
  final String email;
  final String date;

  String price;

  _viewAppointment(this.salonname, this.email, this.date) {

  }

  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();
  bool available = true;


  @override
  Widget build(BuildContext context) {
    /*
    return Scaffold(
        appBar: AppBar(title: Text((salonname)),
          backgroundColor: Colors.deepPurple[700],),
        body:
        Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Text(
                salonname,
                style: TextStyle(fontSize: 18),
              ),

              Expanded(

                child: ListView.builder(

                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: Appointments.length,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  itemBuilder: (BuildContext context, int index) =>
                      Container(

                        width: 200,
                        child: Card(
                          //child: Center(child: Text(SalonNames[index])),

                          child: InkWell(
                              splashColor: Colors.deepPurple[50],
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (
                                //     _) =>
                                //     AssignEmployee(Appointments[index])));

                              },
                              child: //Center(child: Text(SalonNames[index])) ,
                              Container(

                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new Text(Appointments[index],
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

                          color: Colors.pink[100],
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

            ])
    );

     */
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(title: Text("View your Appointments"),
            backgroundColor: Colors.white.withOpacity(0.0)),
        body: SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/4-100.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                    child: Column(
                        children: <Widget>[
                          SizedBox(height: 200,),
                          new Container(

                            height: 500,
                            width: 500,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(40)),
                                border: Border.all(
                                  color: Colors.grey[100],
                                ),
                                color: Colors.grey[100]
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
                                                  color: Colors.deepPurple,),
                                                title: Text(
                                                    Appointments[index]
                                                ),
                                                onTap: () async{
                                                },
                                              ),

                                            ),

                                      ),
                                    )
                                )
                              ],
                            ),


                          ),

                        ]))))
    );
  }
}

