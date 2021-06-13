import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'empData.dart';

class EmpBarChartGraph extends StatefulWidget {
  final List<EmpBarChartModel> data;

  const EmpBarChartGraph({Key key, this.data}) : super(key: key);

  @override
  _EmpBarChartGraphState createState() => _EmpBarChartGraphState();
}

class _EmpBarChartGraphState extends State<EmpBarChartGraph> {
  List<EmpBarChartModel> _barChartList;

  @override
  void initState() {
    // TODO: implement initState
    DateTime today=DateTime.now();
    super.initState();
    _barChartList = [
      EmpBarChartModel(today.month.toString(), charts.ColorUtil.fromDartColor(Color(0xFF47505F)), today.year.toString(),1, "someEmployee",0,0)
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<EmpBarChartModel, String>> series = [
      charts.Series(
          id: "Average Ratings",
          data: widget.data,
          domainFn: (EmpBarChartModel series, _) => series.employee,
          measureFn: (EmpBarChartModel series, _) => series.rating,
          colorFn: (EmpBarChartModel series, _) => series.color),
    ];

    return _buildRatingList(series);

  }

  Widget _buildRatingList(series) {
    return _barChartList != null
        ? ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => Divider(
        color: Colors.white,
        height: 5,
      ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _barChartList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: MediaQuery.of(context).size.height/ 2.3,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Average Ratings",
                      style: TextStyle(
                          color: Colors.black, fontSize: 22,
                          fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              Expanded( child: charts.BarChart(
                series,
                animate: true,
                domainAxis: charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
                ),
              )
              ),
            ],
          ),
        );
      },
    )
        : SizedBox();
  }
}