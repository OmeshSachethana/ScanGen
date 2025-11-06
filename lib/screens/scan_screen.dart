import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_gen/screens/database/history_database.dart';
import 'package:scan_gen/screens/models/history_model.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/banner_ad_widget.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  final HistoryDatabase _database = HistoryDatabase.instance;
  final MobileScannerController _controller = MobileScannerController();
  String? result;
  bool isFlashOn = false;
  bool isScanning = true;
  Timer? _debounce;

  void _onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.first;
    final scannedData = barcode.rawValue ?? "No data found";

    if (!isScanning) return; // Prevent multiple detections

    // Debounce to prevent rapid duplicate scans
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          result = scannedData;
          isScanning = false;
        });

        _controller.stop();

        // Save to history
        final history = ScanHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: scannedData,
          timestamp: DateTime.now(),
          isGenerated: false,
        );

        _database.insertHistory(history);
      }
    });
  }

  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    _controller.toggleTorch();
  }

  void _resumeScan() {
    setState(() {
      result = null;
      isScanning = true;
    });
    _controller.start();
  }

  void _shareScannedResult(String data) {
    final String shareText = '''
QR & Barcode App - Scanned Result

Content: $data
Date: ${DateTime.now().toString()}

Scanned via QR & Barcode App
''';
    Share.share(shareText, subject: 'Scanned QR/Barcode Content');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Code"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            onPressed: _toggleFlash,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
                // Dark overlay around the scanning area
                if (isScanning) ...[
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  ClipPath(
                    clipper: _ScannerClipper(),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.greenAccent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const Positioned(
                    top: 100,
                    child: Text(
                      "Align the QR or Barcode within the box",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
                if (!isScanning && result != null)
                  _buildResultCard(context),
              ],
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 50),
          const SizedBox(height: 10),
          const Text(
            "Scan Successful!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 20),
          SelectableText(
            result ?? "No data found",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _resumeScan,
                icon: const Icon(Icons.refresh),
                label: const Text("Scan Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _shareScannedResult(result!),
                icon: const Icon(Icons.share),
                label: const Text("Share"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom clipper for the scanning cutout box
class _ScannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const boxSize = 250.0;
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: boxSize,
          height: boxSize,
        ),
        const Radius.circular(16),
      ))
      ..fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
