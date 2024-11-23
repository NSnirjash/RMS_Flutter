import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple,
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
            colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade300],
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
                  'XYZ RESTAURANT',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Welcome to the Restaurant Management App!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'This app is designed to revolutionize the way restaurants operate. From handling daily operations to improving customer satisfaction, our platform provides a comprehensive suite of tools to support restaurant owners, managers, and staff.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Why Choose Our App?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'Our app empowers you with cutting-edge technology, enabling you to:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const BulletList(
                items: [
                  'Efficiently manage your menus and keep them updated.',
                  'Track and fulfill orders seamlessly.',
                  'Optimize table reservations and reduce waiting times.',
                  'Analyze performance with detailed analytics and reports.',
                  'Improve staff productivity through intuitive task management.',
                  'Enhance customer engagement with feedback tools.',
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Our Mission:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'Our mission is to help restaurant businesses thrive by reducing complexity and enabling seamless operations. '
                    'We are committed to providing innovative solutions that drive growth and ensure exceptional dining experiences for customers.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Meet the Team:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'Our team is composed of passionate individuals with years of experience in the restaurant and technology industries. '
                    'By combining our expertise, we strive to create tools that are both user-friendly and powerful, tailored to the unique needs of the hospitality sector.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'We Value Your Feedback:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'Your input is essential to our growth. Share your suggestions, feedback, or concerns with us. '
                    'We’re constantly working to improve your experience and add features that matter most to you.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'If you have any questions, feel free to reach out to us:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Email: support@restaurantapp.com',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const Text(
                'Phone: +1 800 123 4567',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const Text(
                'Website: www.restaurantapp.com',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  'Thank you for choosing our app to transform your restaurant management experience!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade800,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
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
