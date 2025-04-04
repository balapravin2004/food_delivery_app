import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      backgroundColor: Colors.orange[50],
      body: user == null
          ? Center(
              child: Text(
                "Please log in to view your cart.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cart')
                  .where('userId', isEqualTo: user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading cart"));
                }

                var cartItems = snapshot.data?.docs ?? [];
                if (cartItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, size: 80, color: Colors.orange),
                        SizedBox(height: 10),
                        Text("Your cart is empty.",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }

                double totalPrice = cartItems.fold(
                  0,
                  (sum, item) {
                    Map<String, dynamic> data = item.data() as Map<String, dynamic>;
                    double price = data.containsKey('price') ? (data['price'] ?? 0).toDouble() : 0;
                    int quantity = data.containsKey('quantity') ? (data['quantity'] ?? 1).toInt() : 1;
                    return sum + (price * quantity);
                  },
                );

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          var item = cartItems[index];
                          Map<String, dynamic> data = item.data() as Map<String, dynamic>;
                          String itemId = item.id;
                          String name = data.containsKey('name') ? data['name'] ?? 'Unknown Item' : 'Unknown Item';
                          double price = data.containsKey('price') ? (data['price'] ?? 0).toDouble() : 0;
                          int quantity = data.containsKey('quantity') ? (data['quantity'] ?? 1).toInt() : 1;
                          String imageUrl = data.containsKey('image') ? data['image'] : 'https://via.placeholder.com/100';

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
                              subtitle: Text("₹${price.toStringAsFixed(2)} x $quantity",
                                  style: TextStyle(color: Colors.green, fontSize: 16)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                    onPressed: () => updateQuantity(itemId, quantity - 1),
                                  ),
                                  Text("$quantity", style: TextStyle(fontSize: 18)),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                    onPressed: () => updateQuantity(itemId, quantity + 1),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => removeFromCart(itemId),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("₹${totalPrice.toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => checkout(),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                              child: Text("Proceed to Checkout", style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity < 1) {
      removeFromCart(itemId);
      return;
    }

    FirebaseFirestore.instance
        .collection('cart')
        .doc(itemId)
        .update({'quantity': newQuantity}).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating quantity: $error")),
      );
    });
  }

  void removeFromCart(String itemId) {
    FirebaseFirestore.instance.collection('cart').doc(itemId).delete().catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error removing item: $error")),
      );
    });
  }

  void checkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Checkout"),
        content: Text("Do you want to proceed with checkout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Checkout feature coming soon!")),
              );
            },
            child: Text("Proceed"),
          ),
        ],
      ),
    );
  }
}
