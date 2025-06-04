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
      if (history.length < 2) return '→';
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
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text('$biomarkerName ${getTrend(biomarkerIndex)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 200,
                child: SfCartesianChart(
                  legend:
                      Legend(isVisible: true, position: LegendPosition.bottom),
                  primaryXAxis: NumericAxis(isVisible: false),
                  primaryYAxis: NumericAxis(isVisible: false),
                  series: <ChartSeries<ChartData, int>>[
                    LineSeries<ChartData, int>(
                      name: biomarkerName,
                      dataSource: biomarkerValues,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      color: const Color.fromARGB(255, 255, 162, 82),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Historical Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
                children: biomarkerNames
                    .asMap()
                    .entries
                    .map((entry) => createBiomarkerGraph(entry.key))
                    .toList()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 162, 82)),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
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
