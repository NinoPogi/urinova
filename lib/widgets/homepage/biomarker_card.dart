import 'package:flutter/material.dart';

class BiomarkerCard extends StatefulWidget {
  final String name;
  final String value;
  final Color color;

  const BiomarkerCard({
    super.key,
    required this.name,
    required this.value,
    required this.color,
  });

  @override
  State<BiomarkerCard> createState() => _BiomarkerCardState();
}

class _BiomarkerCardState extends State<BiomarkerCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Work Sans',
                  letterSpacing: -1,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Work Sans',
                    letterSpacing: -1,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
