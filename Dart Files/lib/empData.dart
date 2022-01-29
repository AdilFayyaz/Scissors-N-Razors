import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class EmpBarChartModel {
  String employee;
  String month;
  double rating;
  int day;
  int appointments;
  charts.Color color;

  EmpBarChartModel(String month, charts.Color color, String year, int day, String employee, int appointments, double rating){
    this.month=month;
    this.color=color;
    this.employee=employee;
    this.rating=rating;
    this.appointments=appointments;
    this.day=day;

  }



}

class EmpAppointment{
  int month;
  int year;
  int day;
  String employee;
  double rating;

  EmpAppointment(int day, int month, int year, String employee, double rating){
    this.day=day;
    this.month=month;
    this.year=year;
    this.employee=employee;
    this.rating=rating;
  }

  Print(){
    print(this.month);
  }


}
