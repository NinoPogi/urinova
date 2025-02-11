import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';

class HistoricalDataModal extends StatelessWidget {
  const HistoricalDataModal({super.key});

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final history = biomarkerProvider.history;

    String getTrend(int index) {
      if (history.length < 2) return 'No trend';
      final last = history.last[index];
      final prev = history[history.length - 2][index];
      return last > prev
          ? '↑'
          : last < prev
              ? '↓'
              : '→';
    }

    Widget createBiomarkerGraph(int biomarkerIndex) {
      final biomarkerName = biomarkerNames[biomarkerIndex];
      final biomarkerValues = history
          .asMap()
          .entries
          .map((entry) => ChartData(entry.key, entry.value[biomarkerIndex]))
          .toList();

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                '$biomarkerName ${getTrend(biomarkerIndex)}',
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(isVisible: false),
                  primaryYAxis: NumericAxis(isVisible: false),
                  series: <ChartSeries<ChartData, int>>[
                    LineSeries<ChartData, int>(
                      dataSource: biomarkerValues,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Data'),
      ),
      body: ListView(
        children: biomarkerNames.asMap().entries.map((entry) {
          final index = entry.key;
          return createBiomarkerGraph(index);
        }).toList(),
      ),
    );
  }
}

// Helper class to represent chart data
class ChartData {
  final int x;
  final int y;

  ChartData(this.x, this.y);
}
