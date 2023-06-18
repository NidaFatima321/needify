import 'package:flutter/material.dart';
import 'package:needify/main.dart';
import 'package:pie_chart/pie_chart.dart';

class Earnings extends StatefulWidget {
  const Earnings({Key? key}) : super(key: key);

  @override
  State<Earnings> createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  Map<String, double> dataMap = {
    "Today's Earnings": todayCount.toDouble(),
    "Past Earnings": totalCount.toDouble()-todayCount.toDouble()
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Earnings"),
      ),
      body: SafeArea(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 1,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          ),
        ),
        Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                "TOTAL EARNED",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
              Expanded(child: Text('${profitearned}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))
            ],
          ),
        )
      ])),
    );
  }
}
