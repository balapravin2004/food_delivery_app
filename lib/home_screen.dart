import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'restaurant_detail_screen.dart'; // Import the detail screen
import 'cart_page.dart'; // Import the cart page

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DocumentSnapshot> _restaurants = [];
  List<DocumentSnapshot> _filteredRestaurants = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
    _searchController.addListener(_filterRestaurants);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchRestaurants() async {
    try {
      List<String> collections = ['restaurants', 'restaurant2', 'restaurant3', 'restaurant4', 'restaurant5'];
      List<DocumentSnapshot> allRestaurants = [];

      for (String collection in collections) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collection).get();
        allRestaurants.addAll(snapshot.docs);
      }

      setState(() {
        _restaurants = allRestaurants;
        _filteredRestaurants = allRestaurants;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching restaurants: $e");
      setState(() => _isLoading = false);
    }
  }

  void _filterRestaurants() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRestaurants = _restaurants.where((restaurant) {
        String name = (restaurant['name'] ?? '').toLowerCase();
        String location = (restaurant['location'] ?? '').toLowerCase();
        return name.contains(query) || location.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Please log in to view content.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurants',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.orange[50],
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by name or location...",
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: _filteredRestaurants.isEmpty
                      ? Center(child: Text("No restaurants found."))
                      : ListView.builder(
                          itemCount: _filteredRestaurants.length,
                          itemBuilder: (context, index) {
                            var restaurant = _filteredRestaurants[index];

                            String imageUrl = restaurant['image'] ?? 'https://via.placeholder.com/100';
                            String name = restaurant['name'] ?? 'Unknown Restaurant';
                            String location = restaurant['location'] ?? 'Address Not Available';
                            String contact = restaurant['contact']?.toString() ?? 'Not Available';
                            double rating = (restaurant['rating'] ?? 0).toDouble();

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RestaurantDetailScreen(
                                      restaurantId: restaurant.id,
                                      restaurantName: name,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          imageUrl,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(child: CircularProgressIndicator());
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(Icons.error, size: 50, color: Colors.red);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              location,
                                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Icon(Icons.phone, color: Colors.blue, size: 16),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Call Us: $contact",
                                                  style: TextStyle(fontSize: 16, color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                RatingBarIndicator(
                                                  rating: rating,
                                                  itemBuilder: (context, index) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 20,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "$rating",
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
