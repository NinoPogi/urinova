import 'package:flutter/material.dart';
import 'package:urinova/widgets/insights/historical_data_modal.dart';
import 'package:urinova/widgets/insights/historical_data_widget.dart';
import 'package:urinova/widgets/insights/recommendations_widget.dart';

class HistoricalDataCard extends StatefulWidget {
  const HistoricalDataCard({super.key});

  @override
  State<HistoricalDataCard> createState() => _HistoricalDataCardState();
}

class _HistoricalDataCardState extends State<HistoricalDataCard> {
  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const HistoricalDataModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => (context),
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
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
              'Historical Data 📉',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Work Sans',
                letterSpacing: -1,
              ),
            ),
            HistoricalDataWidget(),
            RecommendationsWidget(),
          ],
        ),
      ),
    );
  }
}
