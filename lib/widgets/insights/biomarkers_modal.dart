import 'package:flutter/material.dart';
import 'package:urinova/constants/biomarker_constant.dart';

class BiomarkersModal extends StatelessWidget {
  const BiomarkersModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Biomarkers Info',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: biomarkerNames.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(biomarkerNames[index],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(biomarkerValues[index].join(', ')),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 162, 82)),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
