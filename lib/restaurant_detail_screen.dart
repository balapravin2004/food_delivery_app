import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  RestaurantDetailScreen({required this.restaurantId, required this.restaurantName});

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  List<DocumentSnapshot> _menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantId)
        .collection('menu')
        .limit(3) // Ensure only three items per restaurant
        .get();

    setState(() {
      _menuItems = snapshot.docs;
    });
  }

  // Function to add items to the Firestore cart
  void addToCart(String itemName, double price) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to add items to the cart.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('cart').add({
        'userId': user.uid, // Associates item with a specific user
        'name': itemName,
        'price': price,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$itemName added to cart!")),
      );
    } catch (error) {
      print("Error adding to cart: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add $itemName to cart.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      backgroundColor: Colors.orange[50],
      body: _menuItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                var menuItem = _menuItems[index];

                String name = menuItem['name'] ?? 'Unknown';
                double price = (menuItem['price'] ?? 0).toDouble();
                String imageUrl = menuItem['image'] ?? 'https://via.placeholder.com/100';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, size: 50, color: Colors.red);
                        },
                      ),
                    ),
                    title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("₹$price", style: TextStyle(color: Colors.green, fontSize: 16)),
                    trailing: ElevatedButton(
                      onPressed: () => addToCart(name, price), // ✅ Uses actual item name and price
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: Text("Add to Cart", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
