import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  RestaurantDetailScreen(
      {required this.restaurantId, required this.restaurantName});

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  List<DocumentSnapshot> _menuItems = [];
  Map<String, dynamic>? _restaurantDetails;

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetails();
    fetchMenu();
  }

  Future<void> fetchRestaurantDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantId)
        .get();

    setState(() {
      _restaurantDetails = snapshot.data() as Map<String, dynamic>?;
    });
  }

  Future<void> fetchMenu() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantId)
        .collection('menu')
        .get();

    setState(() {
      _menuItems = snapshot.docs;
    });
  }

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
        'userId': user.uid,
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
      backgroundColor: Colors.white,
      body: _restaurantDetails == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_restaurantDetails?['image'] ??
                                'https://via.placeholder.com/400'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: 30),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurantName,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            Text(
                              _restaurantDetails?['rating']?.toString() ??
                                  "4.5",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.timer, color: Colors.red, size: 20),
                            Text(
                              "${_restaurantDetails?['delivery_time'] ?? "30"} min",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          _restaurantDetails?['description'] ??
                              "No description available.",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      "Menu",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _menuItems.isEmpty
                      ? Center(child: Text("No items available"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _menuItems.length,
                          itemBuilder: (context, index) {
                            var menuItem = _menuItems[index];
                            String name = menuItem['name'] ?? 'Unknown';
                            double price = (menuItem['price'] ?? 0).toDouble();
                            String imageUrl = menuItem['image'] ??
                                'https://via.placeholder.com/100';

                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("₹$price",
                                    style: TextStyle(color: Colors.green)),
                                trailing: ElevatedButton(
                                  onPressed: () => addToCart(name, price),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange),
                                  child: Text("Add"),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
