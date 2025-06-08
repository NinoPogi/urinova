import 'package:flutter/material.dart';
import 'package:urinova/widgets/header_part.dart';
import 'package:urinova/widgets/insights/diet_simulation_card.dart';
import 'package:urinova/widgets/insights/biomarkers_card.dart';
import 'package:urinova/widgets/insights/historical_data_widget.dart';
import 'package:urinova/widgets/insights/recommendations_widget.dart';

class InsightsPage extends StatelessWidget {
  final VoidCallback onNavigateToProfile;

  const InsightsPage({super.key, required this.onNavigateToProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 161, 210, 206),
      body: ListView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.07,
          left: MediaQuery.of(context).size.width * 0.06,
          right: MediaQuery.of(context).size.width * 0.06,
        ),
        children: [
          HeaderPart(
              name: "Insights 💡", onNavigateToProfile: onNavigateToProfile),
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          HistoricalDataWidget(),
          RecommendationsWidget(),
          DietSimulationCard(),
          BiomarkersCard(),
        ],
      ),
    );
  }
}
