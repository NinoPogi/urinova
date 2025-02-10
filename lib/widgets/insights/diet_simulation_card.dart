import 'package:flutter/material.dart';

class DietSimulationCard extends StatefulWidget {
  const DietSimulationCard({super.key});

  @override
  State<DietSimulationCard> createState() => _DietSimulationCardState();
}

class _DietSimulationCardState extends State<DietSimulationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 420,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
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
      child: Stack(
        children: [
          Text(
            'Diet Simulation 🍎',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Work Sans',
                letterSpacing: -1,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
