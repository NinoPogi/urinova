import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'package:urinova/providers/user_provider.dart';
import 'package:urinova/widgets/testmodal/device_status_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urinova/widgets/testmodal/profile_time_widget.dart';

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

  void _onConfirm() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final biomarkerProvider =
        Provider.of<BiomarkerProvider>(context, listen: false);
    final currentProfile = userProvider.currentProfile;
    if (currentProfile != null) {
      final profileId = currentProfile['id'];
      final userId = userProvider.user!.uid;
      final biomarkers = biomarkerProvider.biomarkers;
      final testData = {
        'date': Timestamp.now(),
        'biomarkers': biomarkers,
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .collection('tests')
          .add(testData);
    }
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
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.6,
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
                      const SizedBox(height: 60),
                      buildProfileAndTestTimeCard(context),
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
                    padding: const EdgeInsets.all(20.0),
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
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      buildProfileAndTestTimeCard(context),
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
