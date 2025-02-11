import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'package:urinova/widgets/testmodal/device_status_widget.dart';

class TestBottomSheet extends StatefulWidget {
  const TestBottomSheet({super.key});

  @override
  State<TestBottomSheet> createState() => _TestBottomSheetState();
}

class _TestBottomSheetState extends State<TestBottomSheet> {
  bool _showSummary = false;

  @override
  void initState() {
    super.initState();
  }

  void _onTestComplete() {
    setState(() {
      _showSummary = true;
    });
  }

  void _onConfirm() {
    Navigator.of(context).pop();
    setState(() {
      _showSummary = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);

    return Container(
      color: Colors.transparent,
      child: DraggableScrollableSheet(
        initialChildSize: 0.81,
        minChildSize: 0.7,
        maxChildSize: 0.81,
        builder: (BuildContext context, ScrollController scrollController) {
          return Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            color: const Color.fromARGB(255, 255, 162, 82),
            elevation: 4,
            child: _showSummary
                ? ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const Text(
                        'Test Summary 🚽',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Work Sans",
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...biomarkerProvider.biomarkers
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final value = entry.value;

                        if (index >= biomarkerNames.length ||
                            index >= biomarkerValues.length) {
                          return SizedBox();
                        }

                        return ListTile(
                          title: Text(
                            biomarkerNames[index],
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: (value < biomarkerValues[index].length)
                              ? Text(
                                  biomarkerValues[index][value],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Invalid value",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.red),
                                ),
                        );
                      }),
                      ElevatedButton(
                        onPressed: _onConfirm,
                        child: const Text('Confirm'),
                      ),
                    ],
                  )
                : ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const Text(
                        'Test Now 🚽',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Work Sans",
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DeviceStatusWidget(onTestComplete: _onTestComplete),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
