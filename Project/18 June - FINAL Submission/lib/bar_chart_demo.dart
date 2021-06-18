

import 'package:elasticcloud/linechart.dart';
import 'package:flutter/material.dart';
import 'bar_chart_graph.dart';
import 'profitloss.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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

final firestoreInstance = FirebaseFirestore.instance;



class BarChartDemo extends StatefulWidget {
  final email;
  final name;
  BarChartDemo(this.email, this.name);
  @override
  _BarChartDemoState createState() => _BarChartDemoState(this.email, this.name);
}
List<String> months=["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
class _BarChartDemoState extends State<BarChartDemo> {
  final email;
  final name;
  _BarChartDemoState(this.email, this.name);
  TextEditingController expense = TextEditingController();
  String profit=" ";


  List<charts.Color> colourList=[
    charts.ColorUtil.fromDartColor(Color(0xFF47505F)),
    charts.ColorUtil.fromDartColor(Colors.red),
    charts.ColorUtil.fromDartColor(Colors.green),
    charts.ColorUtil.fromDartColor(Colors.yellow),
    charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    charts.ColorUtil.fromDartColor(Colors.pink),
    charts.ColorUtil.fromDartColor(Colors.purple)
  ];
  List<BarChartModel> data=[];
  List<BarChartModel> dataline=[];
  List<Appointment> apt=[];
  int currentTotal;
  int prevTotal;
  int monthlyTotal;
  getTotal() async{
    var result= await firestoreInstance.collection("Appointments").where("salon", isEqualTo: this.name).get();
    int temp=0;
    setState(() {
      // print(result.size);
      // print(result.toString());
      result.docs.forEach((res) {

        int cost = res.data()["total"];
        temp+=cost; //was orginally +=0

      });
      currentTotal=temp;

    });

  }

  getAppointments() async {
    var result= await firestoreInstance.collection("Appointments").where("salon", isEqualTo: this.name).get();
    setState(() {
      DateTime today = DateTime.now();
      monthlyTotal=0;
      print(result.size);
      print(result.toString());
      result.docs.forEach((res) {
        Timestamp t = res.data()["datetime"];
        int cost = res.data()["total"];
        print(t);
        DateTime temp = t.toDate();
        DateTime d = new DateTime(temp.year, temp.month, temp.day);
        print(d);
        if (d.month<=today.month)
          apt.add(new Appointment(d.day, d.month, d.year, cost));
      });

      for (int i = 0; i < today.month; i++) {
        data.add(new BarChartModel(
            months[i], colourList[i % 7], today.year.toString(), 1));
      }
      print("Total appointments: " + apt.length.toString());
      print("Total data: " + data.length.toString());
      print("year of appointments: " + apt[0].year.toString());
      print("current year: " + today.year.toString());

      for (int i = 0; i < apt.length; i++) {
        apt[i].Print();
        if (apt[i].year==today.year ) {
          data[apt[i].month - 1].financial += apt[i].cost;
        }
       // print("Cost for month num "+data[i].month+" is "+data[i].financial.toString());

      }

      for (int i = 1; i <= 31; i++) { //initialize for every day in month
        dataline.add(new BarChartModel(
            months[today.month-1], colourList[i % 7], today.year.toString(),i ));
      }

      for (int i=0; i<apt.length; i++){
        if (apt[i].month==today.month){
          monthlyTotal+=apt[i].cost; //get total income for this month
          dataline[apt[i].day-1].financial+=apt[i].cost;
        }
       // print("Cost for day num "+dataline[i].day.toString()+" is "+data[i].financial.toString());
      }

    });



  }

  @override
  void initState() {
    print("Initializing");
    profit=" ";
    // currentTotal=0;
    // prevTotal=0;
    // getTotal();
    // prevTotal=currentTotal;
    getAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // setState(() {
    //   prevTotal=currentTotal;
    // });
    // getTotal();
    // if (currentTotal>prevTotal){
    //   print("A new appointment was booked");
    //   getAppointments();
    // }
    return Scaffold(
      //appBar:
      appBar: AppBar(title:Text(('Annual and Monthly Income Charts')),
      backgroundColor: Colors.deepPurple[700],
      ),
      // AppBar(
      //   title: Text("Annual and Monthly Income Charts"),
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child:Column(
      children: <Widget>[
            Container(
              child: ListView(
                //scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  BarChartGraph(
                    data: data,
                  ),

                ],
              ),

            ),
            SizedBox(height: 100),
            Container(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  LineChartGraph(
                    data: dataline,
                  ),

                ],
              ),

            ),
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, blurRadius: 6, offset: Offset(0, 2))
                  ]),
              height: 50,
              child: TextField(
                controller: expense,
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.black38),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.monetization_on_outlined, color: Colors.pink),
                    hintText: 'Expenses',
                    hintStyle: TextStyle(color: Colors.black38)),
              ),
            ),
            Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: RaisedButton(
            elevation: 5.0,
            onPressed: () async {
              setState(() {
                if (expense.text != null) {
                  profit = (monthlyTotal - int.parse(expense.text)).toString();
                }
                else{
                  profit="Enter Expense";
                }
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.pink,
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Calculate Profit',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                profit==null?"":profit,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      );
  }
}