import 'package:flutter/material.dart';

class RestaurantList extends StatelessWidget {
  final List<Map<String, String>> restaurants = [
    {
      "name": "Pizza Palace",
      "location": "New York, NY",
      "image_url": "https://raw.githubusercontent.com/balapravin2004/images/main/pizza.jpg"
    },
    {
      "name": "Burger House",
      "location": "Los Angeles, CA",
      "image_url": "https://raw.githubusercontent.com/balapravin2004/images/main/burger.jpg"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restaurants")),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          var restaurant = restaurants[index];

          return Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Image.network(
                  restaurant["image_url"]!,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 50, color: Colors.red);
                  },
                ),
                ListTile(
                  title: Text(restaurant["name"]!),
                  subtitle: Text(restaurant["location"]!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
