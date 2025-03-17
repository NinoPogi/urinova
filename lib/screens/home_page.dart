import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'package:urinova/widgets/header_part.dart';
import 'package:urinova/widgets/homepage/test_schedule_card.dart';
import 'package:urinova/widgets/homepage/risk_alert_card.dart';
import 'package:urinova/widgets/homepage/biomarker_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final hasHistory = biomarkerProvider.history.isNotEmpty;

    Color getSeverityColor(int value) {
      if (value <= 1) return Colors.green;
      if (value <= 3) return Colors.orange;
      return Colors.red;
    }

    final List<Map<String, dynamic>> biomarkers = hasHistory
        ? biomarkerProvider.biomarkers.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final value = entry.value;
              final validValue = value < biomarkerValues[index].length
                  ? value
                  : biomarkerValues[index].length - 1;
              final color = getSeverityColor(validValue);
              return {
                "name": biomarkerNames[index],
                "value": biomarkerValues[index][validValue],
                "color": color,
              };
            },
          ).toList()
        : [];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 238),
      body: ListView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.07,
          left: MediaQuery.of(context).size.width * 0.06,
          right: MediaQuery.of(context).size.width * 0.06,
        ),
        children: [
          HeaderPart(name: "Hello, 👋"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TestScheduleCard(),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              RiskAlertCard(),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: hasHistory ? 1095 : 495,
            child: OverflowBox(
              maxWidth: MediaQuery.of(context).size.width,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(42)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.008,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Text(
                        'Recent Biomarkers Summary',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Work Sans',
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      hasHistory
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: biomarkers.length,
                              itemBuilder: (context, index) {
                                final b = biomarkers[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.015),
                                  child: BiomarkerCard(
                                    name: b["name"],
                                    value: b["value"],
                                    color: b["color"],
                                  ),
                                );
                              },
                            )
                          : Text(
                              "Conduct test first",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Work Sans',
                                letterSpacing: -1,
                              ),
                            ),
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
