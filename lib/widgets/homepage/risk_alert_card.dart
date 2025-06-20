import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/biomarker_provider.dart';

class RiskAlertCard extends StatefulWidget {
  const RiskAlertCard({super.key});

  @override
  State<RiskAlertCard> createState() => _RiskAlertCardState();
}

class _RiskAlertCardState extends State<RiskAlertCard> {
  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final hasHighRisk = biomarkerProvider.hasHighRisk();

    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.20,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 162, 82),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 6),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Risk Alert',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Work Sans',
              letterSpacing: -1,
            ),
          ),
          Spacer(),
          Text(
            hasHighRisk ? 'High Risk Alert!' : 'No Risk Alert',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Work Sans',
              letterSpacing: -1,
              color: hasHighRisk ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
