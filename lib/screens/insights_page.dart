import 'package:flutter/material.dart';
import 'package:urinova/widgets/header_part.dart';
import 'package:urinova/widgets/insights/biomarkers_card.dart';
import 'package:urinova/widgets/insights/diet_simulation_card.dart';
import 'package:urinova/widgets/insights/historical_data_card.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 238),
      body: ListView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.07,
          left: MediaQuery.of(context).size.width * 0.06,
          right: MediaQuery.of(context).size.width * 0.06,
        ),
        children: [
          HeaderPart(name: "Insights 💡"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DietSimulationCard(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              HistoricalDataCard(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              BiomarkersCard(),
            ],
          ),
        ],
      ),
    );
  }
}
