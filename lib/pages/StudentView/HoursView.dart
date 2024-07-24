import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
class HoursView extends StatelessWidget {
  final double attended;
  final double total;
  //Map<String, double> map;
  double rd=12;
  HoursView({this.attended=15,this.total=20});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child:PieChart(
              chartRadius:12*rd,
              dataMap: {
                'Got': attended,
                'Miss': total - attended,
              },
              chartType: ChartType.ring,
              colorList: [Colors.deepPurple,Colors.grey],
              chartValuesOptions: const ChartValuesOptions(
                //showChartValueBackground: false,
                showChartValues: false,
                showChartValuesOutside: false,
              ),
              legendOptions: const LegendOptions(showLegends: false),
            )
          
          ),
        SizedBox(height: rd*5,),
        Text("$attended/ $total Hours Completed",style: TextStyle(fontWeight: FontWeight.bold,fontSize: rd*2),),
      ],
    );
  }
}