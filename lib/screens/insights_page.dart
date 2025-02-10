import 'package:flutter/material.dart';
import 'package:urinova/widgets/header_part.dart';
import 'package:urinova/widgets/insights/diet_simulation_card.dart';
import 'package:urinova/widgets/insights/historical_data_card.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 238),
      body: ListView(
        padding: EdgeInsets.only(top: 56, left: 25, right: 25),
        children: [
          HeaderPart(name: "Insights 💡"),
          SizedBox(height: 100),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DietSimulationCard(),
              SizedBox(height: 20),
              HistoricalDataCard(),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 1095,
            child: OverflowBox(
              maxWidth: MediaQuery.of(context).size.width,
              child: Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(42))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 75,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      SizedBox(height: 28),
                      Text(
                        'Biomarkers 🎓',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Work Sans',
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 22),
                      // Column(
                      //   children: biomarkers
                      //       .map((b) => Padding(
                      //             padding: const EdgeInsets.only(
                      //                 bottom: 12.0), // Add spacing
                      //             child: BiomarkerCard(
                      //               name: b["name"],
                      //               value: b["value"],
                      //               color: b["color"],
                      //             ),
                      //           ))
                      //       .toList(),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
