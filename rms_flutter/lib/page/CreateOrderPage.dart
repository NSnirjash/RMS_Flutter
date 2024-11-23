import 'package:flutter/material.dart';
import 'package:rms_flutter/model/Order.dart';
import 'package:rms_flutter/model/OrderItem.dart';
import 'package:rms_flutter/model/food.dart';
import 'package:rms_flutter/page/OrderListPage.dart';
import 'package:rms_flutter/page/UserPage.dart';
import 'package:rms_flutter/service/AuthService.dart';
import 'package:rms_flutter/service/FoodService.dart';
import 'package:rms_flutter/service/OrderService.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {

  final FoodService _foodService = FoodService();
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();

  List<Food> _foodList = [];
  List<OrderItems> _orderItems = [];
  late OrderModel _order;

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _initializeOrder();
  }

  Future<void> _loadFoods() async {
    try {
      final foods = await _foodService.fetchFoods();
      setState(() {
        _foodList = foods;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load foods: $e')),
      );
    }
  }

  Future<void> _initializeOrder() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _order = OrderModel(user: user, orderItems: [], totalPrice: 0);
    });
  }

  void _incrementQuantity(Food food) {
    final existingItem = _orderItems.firstWhere(
          (item) => item.food?.id == food.id,
      orElse: () {
        final newItem = OrderItems(food: food, quantity: 0);
        _orderItems.add(newItem);
        return newItem;
      },
    );

    setState(() {
      existingItem.quantity = (existingItem.quantity ?? 0) + 1; // Handle nullable quantity
      _updateOrder();
    });
  }



  void _decrementQuantity(Food food) {
    final existingItem = _orderItems.firstWhere(
          (item) => item.food?.id == food.id,
      orElse: () {
        final newItem = OrderItems(food: food, quantity: 0);
    _orderItems.add(newItem);
    return newItem;
  },
    );

    if (existingItem != null) {
      setState(() {
        if ((existingItem.quantity ?? 0) > 0) {
          existingItem.quantity = (existingItem.quantity ?? 0) - 1;
          if (existingItem.quantity == 0) {
            _orderItems.remove(existingItem);
          }
        }
        _updateOrder();
      });
    }
  }

  void _updateOrder() {
    setState(() {
      _order.orderItems = _orderItems;
      _order.totalPrice = _orderItems.fold<double>(
        0.0, // Explicitly define the initial value as a double
            (double sum, item) => sum +
            ((item.food?.price ?? 0.0) * (item.quantity ?? 0)), // Handle nulls explicitly
      );
    });
  }

  Future<void> _placeOrder() async {
    try {
      await _orderService.createOrder(_order);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrderListPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }

  int _getFoodQuantity(int? foodId) {
    final item = _orderItems.firstWhere(
          (item) => item.food?.id == foodId,
      orElse: () => OrderItems(food: null, quantity: 0), // Provide a default OrderItems instance
    );

    return item?.quantity ?? 0; // Safely return the quantity
  }

  bool _isFoodSelected(int? foodId) {
    // Check if the food item with the given ID exists in the selected items
    return _orderItems.any((item) => item.food?.id == foodId);
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
              MaterialPageRoute(builder: (context) => UserPage()),
            );
          },
        ),
        title: Text('Order Food',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _foodList.length,
              itemBuilder: (context, index) {
                final food = _foodList[index];
                return Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          'http://localhost:8090/images/${food.image}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 80),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              food.name ?? 'Unknown Food',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Price: \$${food.price?.toStringAsFixed(2)}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: _isFoodSelected(food.id)
                                      ? () => _decrementQuantity(food)
                                      : null,
                                ),
                                Text(_getFoodQuantity(food.id).toString()),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => _incrementQuantity(food),
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
            ),
          ),
          Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  ..._orderItems.map((item) => ListTile(
                    title: Text('${item.food?.name} x${item.quantity}'),
                    trailing:
                    Text(
                      '\$${((item.food?.price ?? 0) * (item.quantity ?? 0)).toStringAsFixed(2)}',
                    ),
                  )),
                  Divider(),
                  Text(
                    'Total: \$${_order.totalPrice?.toStringAsFixed(2)}',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _orderItems.isNotEmpty ? _placeOrder : null,
                    child: Text('Place Order'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
