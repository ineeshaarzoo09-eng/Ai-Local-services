import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: const [
                  Icon(Icons.privacy_tip, size: 48, color: Colors.teal),
                  SizedBox(height: 8),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),

            // Introduction Section
            _buildSection(
              title: 'Introduction',
              content:
                  'We value your privacy and are committed to protecting your personal information. This policy explains what data we collect, how we use it, and your rights.',
            ),

            const SizedBox(height: 12),

            // Data Collection Section
            _buildSection(
              title: 'Data Collection',
              content:
                  'We may collect personal information such as your name, email address, phone number, and usage data to provide better services and improve your experience.',
            ),

            const SizedBox(height: 12),

            // Data Usage Section
            _buildSection(
              title: 'How We Use Your Data',
              content:
                  'Your data is used to provide and improve services, communicate updates, personalize your experience, and ensure security. We do not sell your information to third parties.',
            ),

            const SizedBox(height: 12),

            // User Rights Section
            _buildSection(
              title: 'Your Rights',
              content:
                  'You have the right to access, update, or delete your personal information at any time. You can also opt-out of marketing communications or data collection where applicable.',
            ),

            const SizedBox(height: 12),

            // Security Section
            _buildSection(
              title: 'Security',
              content:
                  'We implement industry-standard measures to protect your data. However, no method of transmission over the Internet is 100% secure, and we cannot guarantee absolute security.',
            ),

            const SizedBox(height: 12),

            // Contact Section
            _buildSection(
              title: 'Contact Us',
              content:
                  'For any questions or concerns regarding this privacy policy, you can contact us at privacy@yourapp.com or visit our support section in the app.',
            ),

            const SizedBox(height: 24),
            Center(
              child: Text(
                'Last Updated: 23-Aug-2025',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build sections with cards
  Widget _buildSection({required String title, required String content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

