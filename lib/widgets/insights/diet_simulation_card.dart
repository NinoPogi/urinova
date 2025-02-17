import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'package:urinova/widgets/insights/diet_simulation_modal.dart';

class DietSimulationCard extends StatefulWidget {
  const DietSimulationCard({super.key});

  @override
  State<DietSimulationCard> createState() => _DietSimulationCardState();
}

class _DietSimulationCardState extends State<DietSimulationCard> {
  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const DietSimulationModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showModal(context),
      child: Container(
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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
