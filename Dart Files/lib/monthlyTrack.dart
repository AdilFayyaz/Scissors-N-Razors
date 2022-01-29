

import 'package:elasticcloud/linechart.dart';
import 'package:flutter/material.dart';
import 'bar_chart_graph.dart';
import 'empLine.dart';
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



class EmpLineChart extends StatefulWidget {
  final email;
  final name;
  final ename;
  EmpLineChart(this.email, this.name, this.ename);
  @override
  _EmpLineChartState createState() => _EmpLineChartState(this.email, this.name, this.ename);
}
List<String> months=["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
class _EmpLineChartState extends State<EmpLineChart> {
  final email;
  final name;
  final ename;
  _EmpLineChartState(this.email, this.name, this.ename);



  List<charts.Color> colourList=[

    charts.ColorUtil.fromDartColor(Colors.red),
    charts.ColorUtil.fromDartColor(Colors.green),
    charts.ColorUtil.fromDartColor(Colors.yellow),
    charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    charts.ColorUtil.fromDartColor(Colors.pink),
    charts.ColorUtil.fromDartColor(Colors.purple),
    charts.ColorUtil.fromDartColor(Color(0xFF47505F)),
  ];
  List<EmpBarChartModel> dataline=[];
  List<EmpAppointment> apt=[];


  getEmpAppointments() async {
    var result= await firestoreInstance.collection("Appointments").where("salon", isEqualTo: this.name).get();
    setState(() {
      result.docs.forEach((res) {
        double rating=0;
        if (res.data().containsKey('employee')) {
          Timestamp t = res.data()["datetime"];
          DateTime temp = t.toDate();
          DateTime d = new DateTime(temp.year, temp.month, temp.day);
          String employee=res.data()['employee'];
          apt.add(new EmpAppointment(d.day, d.month, d.year, employee, rating));
        }
      });
      DateTime today = DateTime.now();

      for (int i = 1; i <= 31; i++) { //initialize for every day in month
        dataline.add(new EmpBarChartModel(months[today.month-1], colourList[i%7], today.year.toString(), i, ename, 0,0));
      }

      for (int i=0; i<apt.length; i++){
        if (apt[i].month==today.month && apt[i].employee==ename){
          dataline[apt[i].day-1].appointments+=1;
        }
      }

    });



  }

  @override
  void initState() {
    print("Initializing");
    getEmpAppointments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar:
      appBar: AppBar(title:Text(('Daily Performance')),
        backgroundColor: Colors.deepPurple[700],
      ),
      body: SingleChildScrollView(
        child:Column(
          children: <Widget>[
            Container(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  EmpLineChartGraph(
                    data: dataline,
                  ),

                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}