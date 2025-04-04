import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "App Information",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("About the App"),
            _buildInfoCard(
              icon: Icons.info,
              title: "What is this app?",
              description:
                  "This application helps users find the best restaurants, view ratings, and explore detailed information with an easy-to-use interface.",
            ),
            SizedBox(height: 10),
            _buildSectionTitle("Features"),
            _buildInfoCard(
              icon: Icons.restaurant,
              title: "Discover Restaurants",
              description:
                  "Browse through a curated list of top restaurants in your area with detailed ratings and reviews.",
            ),
            _buildInfoCard(
              icon: Icons.star,
              title: "User Ratings",
              description:
                  "Check ratings and reviews given by other customers before making a dining decision.",
            ),
            _buildInfoCard(
              icon: Icons.shopping_cart,
              title: "Easy Ordering",
              description:
                  "Seamlessly place orders and add items to your cart for a smooth dining experience.",
            ),
            SizedBox(height: 10),
            _buildSectionTitle("Frequently Asked Questions"),
            _buildInfoCard(
              icon: Icons.question_answer,
              title: "How do I search for a restaurant?",
              description:
                  "Use the search bar on the home screen to look for restaurants by name or location.",
            ),
            _buildInfoCard(
              icon: Icons.lock,
              title: "Is my data secure?",
              description:
                  "Yes, we use high-level encryption to ensure your data remains safe and private.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon,
      required String title,
      required String description}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.orange, size: 30),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
