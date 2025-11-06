import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/interstitial_ad_helper.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final TextEditingController _controller = TextEditingController();
  String data = "";
  late InterstitialAdHelper _adHelper;

  @override
  void initState() {
    super.initState();
    _adHelper = InterstitialAdHelper();
    _adHelper.loadAd(); // Load the ad once the screen opens
  }

  void _generateQRCode() {
    setState(() {
      data = _controller.text;
    });
  }

  void _handleGenerate() {
    _adHelper.showAd(onAdClosed: _generateQRCode);
  }

  @override
  void dispose() {
    _controller.dispose();
    _adHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate QR Code")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter text to generate QR",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleGenerate,
              child: const Text("Generate"),
            ),
            const SizedBox(height: 24),
            if (data.isNotEmpty)
              QrImageView(
                data: data,
                size: 200,
                backgroundColor: Colors.white,
              ),
            const Spacer(),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
