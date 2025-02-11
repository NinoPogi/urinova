import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'screens/home_page.dart';
import 'screens/recommend_page.dart';
import 'screens/insights_page.dart';
import 'screens/profile_page.dart';
import 'screens/test_modal.dart';
import 'screens/first_time_setup.dart';
import 'providers/profile_provider.dart';

class Urinova extends StatelessWidget {
  const Urinova({super.key});

  Future<bool> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    return isFirstTime;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => BiomarkerProvider()),
      ],
      child: MaterialApp(
        title: 'Urinova',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: true,
        home: FutureBuilder<bool>(
          future: _checkFirstTime(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasData && snapshot.data!) {
              return FirstTimeSetupPage();
            } else {
              return const Main();
            }
          },
        ),
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    RecommendPage(),
    InsightsPage(),
    ProfilePage(),
  ];

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(42)),
      ),
      builder: (BuildContext context) {
        return const TestBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! < -10) {
          _showModal(context);
        }
      },
      child: Scaffold(
          body: _pages[_currentIndex],
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showModal(context),
            shape: RoundedRectangleBorder(
                side: BorderSide(width: .5, color: Colors.grey),
                borderRadius: BorderRadius.circular(42)),
            backgroundColor: const Color.fromARGB(255, 255, 162, 82),
            label: const Text(
              "Test Now",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            elevation: 0,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
              color: Colors.grey,
              width: .5,
            ))),
            padding: const EdgeInsets.only(bottom: 12, top: 6),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              backgroundColor: Colors.transparent,
              elevation: 0,
              indicatorColor: const Color.fromARGB(255, 255, 218, 186),
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.book),
                  label: 'Recommend',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.lightbulb),
                  label: 'Insight',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          )),
    );
  }
}
