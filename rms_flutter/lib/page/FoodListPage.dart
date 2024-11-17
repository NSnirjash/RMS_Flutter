

import 'package:flutter/material.dart';
import 'package:rms_flutter/model/food.dart';
import 'package:rms_flutter/page/AddFoodPage.dart';
import 'package:rms_flutter/page/AdminPage.dart';
import 'package:rms_flutter/service/FoodService.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({super.key});

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  late Future<List<Food>> futureFoods;

  @override
  void initState() {
    super.initState();
    futureFoods = FoodService().fetchFoods();
  }

  // Function to refresh the list
  void _refreshFoodList() {
    setState(() {
      futureFoods = FoodService().fetchFoods(); // Refresh the food list
    });
  }

  // Function to delete a food item
  // Future<void> _deleteFood(int foodId) async {
  //   try {
  //     await FoodService().deleteFood(foodId);
  //     setState(() {
  //       futureFoods = FoodService().fetchFoods(); // Refresh the list
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Food item deleted successfully!')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error deleting food item: $e')),
  //     );
  //   }
  // }

  // Function to navigate to the edit food page (replace with your edit page logic)
  void _editFood(Food food) {
    // Navigate to your edit food page
    print('Edit food: ${food.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminPage()),
            );
          },
        ),
        title: Text(
          'All Food Items',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          // Refresh icon
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshFoodList,  // Trigger the refresh when pressed
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<Food>>(
        future: futureFoods,
        builder: (BuildContext context, AsyncSnapshot<List<Food>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No food available'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final food = snapshot.data![index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image with rounded corners and shadow
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: food.image != null
                            ? Image.network(
                          "http://localhost:8090/images/${food.image}",
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.fastfood,
                              size: 80,
                              color: Colors.grey[400],
                            );
                          },
                        )
                            : Image.asset(
                          'assets/placeholder.png',
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name ?? 'Unnamed Food',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              food.category ?? 'No category available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Available: ${food.available}', // Added "Available" text
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editFood(food),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => (),       //_deleteFood(food.id!)
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFoodPage()),
          );
        },
      ),
    );
  }
}
