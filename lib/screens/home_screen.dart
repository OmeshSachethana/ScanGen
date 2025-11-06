import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'generate_screen.dart';
import '../widgets/banner_ad_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR & Barcode App')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanScreen()),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scan QR / Barcode"),
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
                ),
              ],
            ),
          ),
          const Spacer(),
          const BannerAdWidget(), // 👇 Banner Ad here
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
