import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade200, Colors.grey.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'We’re Here to Help!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'How can we assist you?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Explore the resources below or contact us for personalized support.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 25.0),
              _buildSectionTitle('Frequently Asked Questions', Colors.purple),
              const BulletList(
                items: [
                  'How do I reset my password?',
                  'How can I update menu items?',
                  'What do I do if an order is stuck in processing?',
                  'How can I manage staff accounts?',
                  'Where can I view detailed analytics reports?',
                ],
              ),
              const SizedBox(height: 25.0),
              _buildSectionTitle('Quick Tips', Colors.green),
              const BulletList(
                items: [
                  'Update the app regularly for new features.',
                  'Use the “Help” option in any section for guides.',
                  'Save important actions like analytics export offline.',
                ],
              ),
              const SizedBox(height: 25.0),
              _buildSectionTitle('Contact Our Support Team', Colors.blue),
              const Text(
                'Feel free to reach us via:',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 10.0),
              const ContactDetails(),
              const SizedBox(height: 25.0),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent.shade400,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                  ),
                  icon: const Icon(Icons.headset_mic, color: Colors.white),
                  label: const Text(
                    'Get Support',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    // Add your contact support logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Connecting to support...'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25.0),
              Center(
                child: Text(
                  'We value your feedback!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.teal.shade900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 30,
          color: color,
        ),
        const SizedBox(width: 8.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '\u2022 ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                item,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      )
          .toList(),
    );
  }
}

class ContactDetails extends StatelessWidget {
  const ContactDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          '📧 Email: support@restaurantapp.com',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Text(
          '📞 Phone: +1 800 123 4567',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Text(
          '💬 Live Chat: Available in the app under “Support”.',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
