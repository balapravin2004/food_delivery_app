import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          "Welcome to the Food Delivery App!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
