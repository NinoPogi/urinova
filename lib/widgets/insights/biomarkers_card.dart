import 'package:flutter/material.dart';
import 'package:urinova/widgets/insights/biomarkers_modal.dart';

class BiomarkersCard extends StatefulWidget {
  const BiomarkersCard({super.key});

  @override
  State<BiomarkersCard> createState() => _BiomarkersCardState();
}

class _BiomarkersCardState extends State<BiomarkersCard> {
  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const BiomarkersModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showModal(context),
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 6),
                spreadRadius: -8),
          ],
        ),
        child: const Text(
          'Biomarkers 🎓',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Work Sans',
              letterSpacing: -1),
        ),
      ),
    );
  }
}
