import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BarChartModel {
  String month;
  String year;
  int day;
  int financial;
  charts.Color color;

  BarChartModel(String month, charts.Color color, String year, int day){
    this.month=month;
    this.color=color;
    this.year=year;
    this.financial=0;
    this.day=day;

  }



}

class Appointment{
  int month;
  int year;
  int day;
  int cost;

  Appointment(int day, int month, int year, int cost){
    print("Received year as "+year.toString());
    this.day=day;
    this.month=month;
    this.year=year;
    print("Assigned month as "+month.toString());
    this.cost=cost;
  }

  Print(){
    print(this.month);
  }


}
