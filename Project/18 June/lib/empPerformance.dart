


import 'package:elasticcloud/alertDialog.dart';
import 'package:elasticcloud/linechart.dart';
import 'package:elasticcloud/monthlyTrack.dart';
import 'package:flutter/material.dart';
import 'bar_chart_graph.dart';
import 'profitloss.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'addSalon.dart';
import 'ManageServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "empData.dart";
import "ratingGraph.dart";
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSalonOwner.dart';
import 'getInformation.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

final firestoreInstance = FirebaseFirestore.instance;



class EmpBarChart extends StatefulWidget {
  final email;
  final name;
  EmpBarChart(this.email, this.name);
  @override
  _EmpBarChartState createState() => _EmpBarChartState(this.email, this.name);
}
List<String> months=["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
class _EmpBarChartState extends State<EmpBarChart> {
  final email;
  final name;
  _EmpBarChartState(this.email, this.name);
  TextEditingController expense = TextEditingController();
  TextEditingController ename = TextEditingController();
  String profit=" ";


  List<charts.Color> colourList=[

    charts.ColorUtil.fromDartColor(Colors.red),
    charts.ColorUtil.fromDartColor(Colors.green),
    charts.ColorUtil.fromDartColor(Colors.yellow),
    charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    charts.ColorUtil.fromDartColor(Colors.pink),
    charts.ColorUtil.fromDartColor(Colors.purple),
    charts.ColorUtil.fromDartColor(Color(0xFF47505F)),
  ];
  List<EmpBarChartModel> data=[];
  List<EmpBarChartModel> dataline=[];
  List<EmpAppointment> apt=[];
  List<String> employees=[];

  getEmployees() async{
    var result=await firestoreInstance.collection("Salon").doc(this.name).collection('Employees').get();
    setState(() {
      result.docs.forEach((res) {
        employees.add(res.id.toString());
      });
      print("Total employees are "+employees.length.toString());
    });
  }


  getEmpAppointments() async {
    var result= await firestoreInstance.collection("Appointments").where("salon", isEqualTo: this.name).get();
    setState(() {
      result.docs.forEach((res) {
        double rating=-1;
        if (res.data().containsKey('employee')) {
          Timestamp t = res.data()["datetime"];
          DateTime temp = t.toDate();
          DateTime d = new DateTime(temp.year, temp.month, temp.day);
          String employee=res.data()['employee'];
          if (res.data().containsKey('rating')){
            rating=double.parse(res.data()['rating']);
          }
          print(employee);
          print(rating);
          apt.add(new EmpAppointment(d.day, d.month, d.year, employee, rating));
        }
      });
      print("*********** Appointments fecthed: "+apt.length.toString());
      DateTime today = DateTime.now();
      print("Employee length is*******************"+employees.length.toString());
      for (int i = 0; i < employees.length; i++) {
        data.add(new EmpBarChartModel(months[today.month-1], colourList[i%7], today.year.toString(), today.day, employees[i], 0,0));
      }
      print("*********************Data Size: "+data.length.toString());
      for(int i=0; i<data.length; i++ ){
        double numReviews=0;
        double sum=0;
        for (int j=0; j<apt.length; j++){
          if (data[i].employee==apt[j].employee && apt[j].rating!=-1){
            sum+=apt[j].rating;
            numReviews+=1;
          }
        }
        if(numReviews!=0) {
          double avgRating = sum / numReviews;
          data[i].rating = avgRating;
        }
        else{
          data[i].rating=0;
        }
      }

      for (int i = 1; i <= 31; i++) { //initialize for every day in month
        dataline.add(new EmpBarChartModel(months[today.month-1], colourList[i%7], today.year.toString(), i, ename.text, 0,0));
      }

      for (int i=0; i<apt.length; i++){
        if (apt[i].month==today.month && apt[i].employee==ename.text){
          dataline[apt[i].day-1].appointments+=1;
        }
      }

    });



  }

  @override
  void initState() {
    print("Initializing");
    profit=" ";
    getEmployees();
    getEmpAppointments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar:
      appBar: AppBar(title:Text(('Employee Performance Tracker')),
        backgroundColor: Colors.deepPurple[700],
      ),
      body: SingleChildScrollView(
        child:Column(
          children: <Widget>[
            Container(
              child: ListView(
                //scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 40),
                children: [
                  EmpBarChartGraph(
                    data: data,
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
                controller: ename,
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.black38),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.person_pin, color: Colors.pink),
                    hintText: 'Employee Name',
                    hintStyle: TextStyle(color: Colors.black38)),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: RaisedButton(
                elevation: 5.0,
                onPressed: () async {
                  if (employees.contains(ename.text)) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => EmpLineChart(email, name, ename.text)));
                  }
                  else{
                    DialogBox d= new DialogBox();
                    d.showDialogInfo(context, "Wrong Name", "No Such Employee");
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.pink,
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Get This Month\'s Stats',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}