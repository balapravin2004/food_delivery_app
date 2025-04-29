import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'restaurant_detail_screen.dart';
import 'cart_page.dart';
import 'profile_screen.dart';
import 'information_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
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
      List<String> collections = ['restaurants', 'restaurant2'];
      List<DocumentSnapshot> allRestaurants = [];

      for (String collection in collections) {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection(collection).get();
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

  Widget _buildRestaurantList() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search restaurants...",
              prefixIcon: Icon(Icons.search, color: Colors.orange),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        _isLoading
            ? Expanded(child: Center(child: CircularProgressIndicator(color: Colors.orange)))
            : Expanded(
                child: _filteredRestaurants.isEmpty
                    ? Center(child: Text("No restaurants found."))
                    : ListView.builder(
                        itemCount: _filteredRestaurants.length,
                        itemBuilder: (context, index) {
                          var restaurant = _filteredRestaurants[index];
                          return _buildRestaurantCard(restaurant);
                        },
                      ),
              ),
      ],
    );
  }

  Widget _buildRestaurantCard(DocumentSnapshot restaurant) {
    String imageUrl = restaurant['image'] ?? 'https://via.placeholder.com/100';
    String name = restaurant['name'] ?? 'Unknown Restaurant';
    String location = restaurant['location'] ?? 'Address Not Available';
    double rating = (restaurant['rating'] ?? 0.0).toDouble();

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(location, style: TextStyle(fontSize: 14)),
        trailing: Icon(Icons.star, color: Colors.amber, size: 20),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      InformationScreen(),
      _buildRestaurantList(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Restaurant', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
