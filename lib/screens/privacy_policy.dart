import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Privacy Policy for ScanGen",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Effective Date: November 6, 2025"),
            SizedBox(height: 20),

            Text(
              "ScanGen (“we”, “our”, or “the App”) respects your privacy and is committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our app.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 20),
            Text("1. Information We Collect",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "• We do not collect personally identifiable information unless you voluntarily provide it.\n"
              "• ScanGen may collect anonymous usage data for analytics and to improve app performance.\n"
              "• Ads displayed in the app may collect data as per the ad provider’s policies.\n"
              "• The app requests access to your device’s camera solely for scanning QR and barcodes. No images or videos are stored or transmitted.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 20),
            Text("2. How We Use Your Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "• To display ads via Google AdMob.\n"
              "• To improve app functionality and user experience.\n"
              "• For app analytics and crash reporting.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 20),
            Text("3. Third-Party Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Our app uses Google Mobile Ads (AdMob), which may collect anonymous data in accordance with its privacy policy.\n\n"
              "For more details, see Google AdMob Privacy Policy: https://policies.google.com/privacy",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 20),
            Text("4. Data Security",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "We take reasonable measures to protect your information. However, no method of transmission over the internet is 100% secure.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 20),
            Text("5. Children’s Privacy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Our app is not directed toward children under 13. We do not knowingly collect any personal information from children.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 20),
            Text("6. Changes to This Policy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "We may update this Privacy Policy from time to time. Any changes will be reflected with an updated effective date.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 20),
            Text("7. Contact Us",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "If you have any questions or concerns about this Privacy Policy, please contact us at:\n\n"
              "📧 Email: codebyteslabs@gmail.com",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 30),
            Center(
              child: Text(
                "© 2025 CodeByte Labs. All rights reserved.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
