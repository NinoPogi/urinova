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
      'long': [1, 0, 0, 0, 0, 1, 2, -2, 0, 0],
    },
    'High-Protein Diet': {
      'short': [0, 0, 0, 1, 0, 1, 2, -2, 1, 0],
      'medium': [0, 0, 0, 1, 0, 1, 3, -2, 1, 0],
      'long': [1, 0, 0, 0, 0, 1, 3, -2, 1, 0],
    },
    'Vegan/Plant-Based Diet': {
      'short': [0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      'medium': [0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      'long': [0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    },
    'High-Sugar/Processed Food Diet': {
      'short': [0, 1, 0, 0, 1, 1, 0, 2, 1, 0],
      'medium': [0, 1, 0, 0, 1, 1, 0, 3, 1, 0],
      'long': [1, 1, 0, 0, 1, 1, 0, 3, 1, 0],
    },
    'Intermittent Fasting (IF)': {
      'short': [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
      'medium': [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
      'long': [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
    },
    'Mediterranean Diet': {
      'short': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      'medium': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      'long': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    },
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    if (biomarkerProvider.history.isNotEmpty) {
      _lastHistory = List.from(biomarkerProvider.history.last);
    }
  }

  void _clearResults() {
    setState(() {
      _showResults = false;
      _simulatedBiomarkers = [];
    });
  }

  void _onDietChanged(String? value) {
    setState(() {
      _selectedDiet = value;
      _clearResults();
    });
  }

  void _onDurationChanged(String? value) {
    setState(() {
      _selectedDuration = value;
      _clearResults();
    });
  }

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

      if (current > previous) return '↑ Increasing';
      if (current < previous) return '↓ Decreasing';
      return '→ Stable';
    } else {
      final effect = _dietEffects[_selectedDiet]![_selectedDuration]![index];
      if (effect > 0) return '↑ Increasing';
      if (effect < 0) return '↓ Decreasing';
      return '→ Stable';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text('Diet Simulation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _selectedDiet,
            hint: Text('Select Diet'),
            items: _dietEffects.keys.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: _onDietChanged,
          ),
          DropdownButton<String>(
            value: _selectedDuration,
            hint: Text('Select Duration'),
            items: ['short', 'medium', 'long'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: _onDurationChanged,
          ),
          ElevatedButton(
            onPressed: _runSimulation,
            child: Text('Run Simulation'),
          ),
          if (_showResults)
            Expanded(
              child: ListView(
                children: _simulatedBiomarkers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final value = entry.value;
                  final color = value <= 1
                      ? Colors.green
                      : value <= 3
                          ? Colors.orange
                          : Colors.red;
                  return Card(
                    child: ListTile(
                      title: Text(biomarkerNames[index]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Value: ${biomarkerValues[index][value]}'),
                          Text('Trend: ${_getTrend(index)}',
                              style: TextStyle(
                                color: _getTrend(index).contains('↑')
                                    ? Colors.red
                                    : _getTrend(index).contains('↓')
                                        ? Colors.green
                                        : Colors.grey,
                              )),
                        ],
                      ),
                      trailing: Container(
                        width: 20,
                        height: 20,
                        color: color,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
