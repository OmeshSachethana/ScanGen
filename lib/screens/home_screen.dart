import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'generate_screen.dart';
import '../widgets/banner_ad_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'QR & Barcode App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false, // Keeps title perfectly centered
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: Column(
              children: [
                // Rounded Icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(20), // makes it round
                  child: Image.asset(
                    'assets/qr_icon.png', // ensure this file exists in pubspec.yaml
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 32),

                const Text(
                  'QR & Barcode',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Scan and Generate QR Codes easily',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 92, 91, 91),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanScreen()),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scan QR / Barcode"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GenerateScreen()),
                    );
                  },
                  icon: const Icon(Icons.qr_code_2),
                  label: const Text("Generate QR Code"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const BannerAdWidget(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
