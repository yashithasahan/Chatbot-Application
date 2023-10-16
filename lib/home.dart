import 'package:echo_ai/chat.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildCharacterMenu(
    String character,
    String description,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              character: character,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 32,
          top: 32,
          bottom: 32,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              offset: Offset(5, 5),
              blurRadius: 50,
              spreadRadius: 5,
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DgMentor Assist',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 32,
                  right: 32,
                ),
                children: [
                  const Text(
                    'Select a Person to Chat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildCharacterMenu(
                    'Product Manager',
                    'As a product manager assistant, I can help you streamline your workflow, prioritize features, and stay organized.',
                  ),
                  const SizedBox(height: 16),
                  _buildCharacterMenu(
                    'Customer Care Assistant',
                    'As a Customer Care Assistant, my mission is to provide exceptional support, handling inquiries, resolving issues, and ensuring customer satisfaction, ensuring 24/7 positive interactions.',
                  ),
                  const SizedBox(height: 16),
                  _buildCharacterMenu(
                    'Sales Assistant',
                    'As a Sales Assistant, my role involves driving sales, guiding customers through the buying process, increasing revenue, identifying valuable leads, and closing deals effectively.',
                  ),
                  const SizedBox(height: 16),
                  _buildCharacterMenu(
                    'Developer',
                    'As a developer, I can help you resolve any technical issue you faced while using our app. Further, if you are requesting an addtionl feature to the app, we can discuss and check the possibility.',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
