import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:scan_gen/screens/database/history_database.dart';
import 'package:scan_gen/screens/models/history_model.dart';
import 'package:share_plus/share_plus.dart';
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
  final HistoryDatabase _database = HistoryDatabase.instance;

  final GlobalKey _qrKey = GlobalKey(); // Key for QR widget capture

  @override
  void initState() {
    super.initState();
    _adHelper = InterstitialAdHelper();
    _adHelper.loadAd();
  }

  void _generateQRCode() {
    setState(() {
      data = _controller.text;
    });

    if (_controller.text.isNotEmpty) {
      final history = ScanHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _controller.text,
        timestamp: DateTime.now(),
        isGenerated: true,
      );

      _database.insertHistory(history);
    }
  }

  void _handleGenerate() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text to generate QR code')),
      );
      return;
    }
    _adHelper.showAd(onAdClosed: _generateQRCode);
  }

  Future<void> _shareGeneratedQR(String data) async {
    try {
      // Capture QR widget as image
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the file temporarily
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png')
          .create();
      await file.writeAsBytes(pngBytes);

      // Share the QR image + content
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '''
QR & Barcode App - Generated QR Code

Content: $data
Date: ${DateTime.now().toString()}

Generated via ScanGen
''',
        subject: 'Generated QR Code',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share QR: $e')),
      );
    }
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
                hintText: "Enter URL, text, or any content",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleGenerate,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Generate QR Code"),
            ),
            const SizedBox(height: 24),
            if (data.isNotEmpty)
              Column(
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RepaintBoundary(
                        key: _qrKey,
                        child: QrImageView(
                          data: data,
                          size: 200,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _shareGeneratedQR(data),
                    icon: const Icon(Icons.share),
                    label: const Text('Share QR Image'),
                  ),
                ],
              ),
            const Spacer(),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
