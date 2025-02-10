import 'package:flutter/material.dart';

class HistoricalDataCard extends StatefulWidget {
  const HistoricalDataCard({super.key});

  @override
  State<HistoricalDataCard> createState() => _HistoricalDataCardState();
}

class _HistoricalDataCardState extends State<HistoricalDataCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 420,
      height: 200,
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
      child: Stack(
        children: [
          Text(
            'Historical Data 📉',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Work Sans',
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}
