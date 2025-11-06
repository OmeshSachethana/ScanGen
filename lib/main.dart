import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/home_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/generate_screen.dart';
import 'screens/history_screen.dart';
import 'utils/admob_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdMobService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR & Barcode App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainDrawerPage(),
    );
  }
}

class MainDrawerPage extends StatefulWidget {
  const MainDrawerPage({super.key});

  @override
  State<MainDrawerPage> createState() => _MainDrawerPageState();
}

class _MainDrawerPageState extends State<MainDrawerPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ScanScreen(),
    GenerateScreen(),
    HistoryScreen(),
  ];

  final List<String> _titles = const [
    "Home",
    "Scan QR / Barcode",
    "Generate QR Code",
    "History",
  ];

  void _onItemTap(int index) {
    Navigator.pop(context); // close the drawer
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade600),
              child: const Center(
                child: Text(
                  "ScanGen",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => _onItemTap(0),
              selected: _selectedIndex == 0,
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan QR / Barcode'),
              onTap: () => _onItemTap(1),
              selected: _selectedIndex == 1,
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_2),
              title: const Text('Generate QR Code'),
              onTap: () => _onItemTap(2),
              selected: _selectedIndex == 2,
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () => _onItemTap(3),
              selected: _selectedIndex == 3,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "QR & Barcode App",
                  applicationVersion: "1.0.0",
                  children: [
                    const Text("Developed by CodeByte Labs\nAll rights reserved © 2025")
                  ],
                );
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}