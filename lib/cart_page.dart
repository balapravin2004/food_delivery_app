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
        title: Text("Your Cart"),
        backgroundColor: Colors.orange,
      ),
      body: user == null
          ? Center(child: Text("Please log in to view your cart."))
          : FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('cart')
                  .where('userId', isEqualTo: user!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading cart"));
                }

                var cartItems = snapshot.data?.docs ?? [];
                if (cartItems.isEmpty) {
                  return Center(child: Text("Your cart is empty."));
                }

                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return ListTile(
                      title: Text(item['name'] ?? 'Unknown Item'),
                      subtitle: Text("Price: \$${item['price'] ?? 'N/A'}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeFromCart(item.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void removeFromCart(String itemId) {
    FirebaseFirestore.instance.collection('cart').doc(itemId).delete();
    setState(() {}); // Refresh UI
  }
}
