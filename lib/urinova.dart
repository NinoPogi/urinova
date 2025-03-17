import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'providers/user_provider.dart';
import 'package:urinova/screens/auth_page.dart';
import 'screens/home_page.dart';
import 'screens/recommend_page.dart';
import 'screens/insights_page.dart';
import 'screens/profile_page.dart';
import 'screens/test_modal.dart';

class Urinova extends StatelessWidget {
  const Urinova({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BiomarkerProvider()),
      ],
      child: MaterialApp(
        title: 'Urinova',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Work Sans',
        ),
        debugShowCheckedModeBanner: true,
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        switch (userProvider.status) {
          case AuthStatus.loading:
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AuthStatus.unauthenticated:
            return AuthPage();
          case AuthStatus.authenticated:
            if (userProvider.profiles.isEmpty) {
              return FirstTimeProfileSetup();
            } else {
              return Main();
            }
        }
      },
    );
  }
}

class FirstTimeProfileSetup extends StatefulWidget {
  @override
  _FirstTimeProfileSetupState createState() => _FirstTimeProfileSetupState();
}

class _FirstTimeProfileSetupState extends State<FirstTimeProfileSetup> {
  final _nameController = TextEditingController();

  Future<void> _completeSetup() async {
    if (_nameController.text.isNotEmpty) {
      await Provider.of<UserProvider>(context, listen: false)
          .addProfile(_nameController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Main()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome! Create your first profile'),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Profile Name'),
              ),
            ),
            ElevatedButton(
              onPressed: _completeSetup,
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

// Rest of Main class remains unchanged
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
          label: const Text("Test Now", style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.add, color: Colors.white),
          elevation: 0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: .5)),
          ),
          padding: const EdgeInsets.only(bottom: 12, top: 6),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: const Color.fromARGB(255, 255, 218, 186),
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            destinations: [
              const NavigationDestination(
                  icon: Icon(Icons.home), label: 'Home'),
              const NavigationDestination(
                  icon: Icon(Icons.book), label: 'Recommend'),
              const NavigationDestination(
                  icon: Icon(Icons.lightbulb), label: 'Insight'),
              const NavigationDestination(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
