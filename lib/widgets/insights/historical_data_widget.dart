import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';

class HistoricalDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final history = biomarkerProvider.history;
    if (history.isEmpty) {
      return Center(child: Text("No historical data available"));
    }
    return Column(
      children: [
        for (int i = 0; i < biomarkerNames.length; i++)
          _BiomarkerTrendWidget(index: i),
      ],
    );
  }
}

class _BiomarkerTrendWidget extends StatelessWidget {
  final int index;
  _BiomarkerTrendWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final history = biomarkerProvider.history;
    final biomarkerName = biomarkerNames[index];
    final values = history.map((test) => test[index]).toList();
    final currentValueIndex = values.last;
    final currentValue = biomarkerValues[index][currentValueIndex];
    String trend = '-';
    if (history.length >= 2) {
      final previous = history[history.length - 2][index];
      if (currentValueIndex > previous)
        trend = '↑';
      else if (currentValueIndex < previous)
        trend = '↓';
      else
        trend = '→';
    }
    final chartData =
        List.generate(history.length, (i) => ChartData(i, values[i]));

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => FullBiomarkerChart(index: index),
        );
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$biomarkerName $trend',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Current: $currentValue'),
              SizedBox(
                height: 100,
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(isVisible: false),
                  primaryYAxis: NumericAxis(isVisible: false),
                  series: <ChartSeries<ChartData, int>>[
                    LineSeries<ChartData, int>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FullBiomarkerChart extends StatelessWidget {
  final int index;
  FullBiomarkerChart({required this.index});

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final history = biomarkerProvider.history;
    final biomarkerName = biomarkerNames[index];
    final values = history.map((test) => test[index]).toList();
    final chartData =
        List.generate(history.length, (i) => ChartData(i, values[i]));

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(biomarkerName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: NumericAxis(title: AxisTitle(text: 'Test Number')),
              primaryYAxis: NumericAxis(title: AxisTitle(text: 'Value Index')),
              series: <ChartSeries<ChartData, int>>[
                LineSeries<ChartData, int>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Text('Historical Values:'),
          for (int i = 0; i < history.length; i++)
            Text('Test ${i + 1}: ${biomarkerValues[index][values[i]]}'),
        ],
      ),
    );
  }
}

class ChartData {
  final int x;
  final int y;
  ChartData(this.x, this.y);
}
