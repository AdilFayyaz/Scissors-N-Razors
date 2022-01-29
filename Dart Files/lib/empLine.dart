/// Example of a simple line chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'bar_chart_demo.dart';
import 'empData.dart';
import 'profitloss.dart';

class EmpLineChartGraph extends StatefulWidget {
  final List<EmpBarChartModel> data;

  const EmpLineChartGraph({Key key, this.data}) : super(key: key);

  @override
  _EmpSimpleLineChart createState() => _EmpSimpleLineChart();
}

class _EmpSimpleLineChart extends State<EmpLineChartGraph> {
  List<EmpBarChartModel> _lineChartList;

  @override
  void initState() {
    // TODO: implement initState
    DateTime today=DateTime.now();
    super.initState();
    _lineChartList = [
      EmpBarChartModel(months[today.month-1], charts.ColorUtil.fromDartColor(Color(0xFF47505F)), today.year.toString(), 1, "somename",0,0)
    ];
  }


  @override
  Widget build(BuildContext context) {
    List<charts.Series<EmpBarChartModel, int>> series = [
      charts.Series(
          id: "Appointments",
          data: widget.data,
          domainFn: (EmpBarChartModel series, _) => series.day,
          measureFn: (EmpBarChartModel series, _) => series.appointments,
          colorFn: (EmpBarChartModel series, _) => series.color),
    ];
    return _buildApptList(series);
  }

  Widget _buildApptList(series) {
    return _lineChartList != null
        ? ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) =>
          Divider(
            color: Colors.white,
            height: 5,
          ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _lineChartList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height / 2.3,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_lineChartList[index].month,
                      style: TextStyle(
                          color: Colors.black, fontSize: 22,
                          fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              Expanded(child: charts.LineChart(series, animate: true,)),
            ],
          ),
        );
      },
    )
        : SizedBox();
  }
}






