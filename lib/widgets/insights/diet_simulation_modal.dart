import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';

class DietSimulationModal extends StatefulWidget {
  const DietSimulationModal({super.key});

  @override
  State<DietSimulationModal> createState() => _DietSimulationModalState();
}

class _DietSimulationModalState extends State<DietSimulationModal> {
  String? _selectedDiet;
  String? _selectedDuration;
  List<int> _simulatedBiomarkers = [];
  bool _showResults = false;
  List<int>? _lastHistory;

  final Map<String, Map<String, List<int>>> _dietEffects = {
    'Keto Diet': {
      'short': [0, 0, 0, 2, 0, 1, 1, -2, 0, 0],
      'medium': [0, 0, 0, 1, 0, 1, 2, -2, 0, 0],
      'long': [1, 0, 0, 0, 0, 1, 2, -2, 0, 0]
    },
    'High-Protein Diet': {
      'short': [0, 0, 0, 1, 0, 1, 2, -2, 1, 0],
      'medium': [0, 0, 0, 1, 0, 1, 3, -2, 1, 0],
      'long': [1, 0, 0, 0, 0, 1, 3, -2, 1, 0]
    },
    'Vegan/Plant-Based Diet': {
      'short': [0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      'medium': [0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      'long': [0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
    },
    'High-Sugar/Processed Food Diet': {
      'short': [0, 1, 0, 0, 1, 1, 0, 2, 1, 0],
      'medium': [0, 1, 0, 0, 1, 1, 0, 3, 1, 0],
      'long': [1, 1, 0, 0, 1, 1, 0, 3, 1, 0]
    },
    'Intermittent Fasting (IF)': {
      'short': [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
      'medium': [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
      'long': [0, 0, 0, 0, 0, 0, 0, 1, 0, 0]
    },
    'Mediterranean Diet': {
      'short': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      'medium': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      'long': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    },
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    if (biomarkerProvider.history.isNotEmpty)
      _lastHistory = List.from(biomarkerProvider.history.last);
  }

  void _onDietChanged(String? value) => setState(() {
        _selectedDiet = value;
        _showResults = false;
        _simulatedBiomarkers = [];
      });

  void _onDurationChanged(String? value) => setState(() {
        _selectedDuration = value;
        _showResults = false;
        _simulatedBiomarkers = [];
      });

  void _runSimulation() {
    if (_selectedDiet == null || _selectedDuration == null) return;
    final effects = _dietEffects[_selectedDiet]![_selectedDuration]!;
    final baseline = _lastHistory ?? List.filled(biomarkerNames.length, 2);
    setState(() {
      _simulatedBiomarkers = List.from(baseline);
      for (int i = 0; i < _simulatedBiomarkers.length; i++) {
        _simulatedBiomarkers[i] = (_simulatedBiomarkers[i] + effects[i])
            .clamp(0, biomarkerValues[i].length - 1);
      }
      _showResults = true;
    });
  }

  String _getTrend(int index) {
    if (_lastHistory != null) {
      final current = _simulatedBiomarkers[index];
      final previous = _lastHistory![index];
      return current > previous
          ? '↑'
          : current < previous
              ? '↓'
              : '→';
    }
    final effect = _dietEffects[_selectedDiet]![_selectedDuration]![index];
    return effect > 0
        ? '↑'
        : effect < 0
            ? '↓'
            : '→';
  }

  Color _getColor(int value) => value <= 1
      ? Colors.green
      : value <= 3
          ? Colors.orange
          : Colors.red;

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
          const Text('Diet Simulation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _selectedDiet,
            hint: const Text('Select Diet'),
            isExpanded: true,
            items: _dietEffects.keys
                .map((value) =>
                    DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: _onDietChanged,
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _selectedDuration,
            hint: const Text('Select Duration'),
            isExpanded: true,
            items: ['short', 'medium', 'long']
                .map((value) =>
                    DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: _onDurationChanged,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _runSimulation,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 162, 82)),
            child: const Text('Run Simulation',
                style: TextStyle(color: Colors.white)),
          ),
          if (_showResults)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 2),
                itemCount: _simulatedBiomarkers.length,
                itemBuilder: (context, index) {
                  final value = _simulatedBiomarkers[index];
                  return Card(
                    color: _getColor(value),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(biomarkerNames[index],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text(biomarkerValues[index][value],
                              style: const TextStyle(color: Colors.white)),
                          Text(_getTrend(index),
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
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
