import 'package:flutter/material.dart';
import 'package:rms_flutter/model/Order.dart';
import 'package:rms_flutter/model/user.dart';
import 'package:rms_flutter/service/AuthService.dart';
import 'package:rms_flutter/service/OrderService.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();

  List<OrderModel> _orderList = [];
  List<User> _waiterList = [];
  User? _currentUser;
  Map<int, int> _selectedWaiters = {}; // Selected waiter IDs by order ID

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
    _loadOrderList();
    if (_isAdmin()) {
      _loadWaiters();
    }
  }

  void _loadOrderList() async {
    if (_currentUser != null) {
      final orders = await _orderService.getAllOrders(_currentUser!.id!);
      setState(() {
        _orderList = orders;
      });
    }
  }

  void _loadWaiters() async {
    final waiters = await _authService.getAllWaiters();
    setState(() {
      _waiterList = waiters;
    });
  }

  bool _isAdmin() {
    return _currentUser?.role == 'ADMIN';
  }

  bool _isApproved(OrderModel order) {
    return order.status == 'APPROVED' || order.status == 'REJECTED';
  }

  int _getTotalQuantity(OrderModel order) {
    return order.orderItems?.fold<int>(
        0, (total, item) => (total ?? 0) + (item.quantity ?? 0)) ??
        0;
  }

  void _approveOrder(int orderId) async {
    final selectedWaiterId = _selectedWaiters[orderId];
    if (selectedWaiterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a waiter to approve order.')));
      return;
    }
    await _orderService.approveOrder(
        orderId, _currentUser!.id!, selectedWaiterId);
    _loadOrderList();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Order approved successfully.')));
  }

  void _rejectOrder(int orderId) async {
    await _orderService.rejectOrder(orderId, _currentUser!.id!);
    _loadOrderList();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Order rejected successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: _orderList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(2),
              6: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[300]),
                children: [
                  Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Food Items', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  if (_isAdmin()) Text('Waiter', style: TextStyle(fontWeight: FontWeight.bold)),
                  if (_isAdmin()) Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              ..._orderList.map((order) {
                return TableRow(
                  children: [
                    Text(order.id?.toString() ?? 'N/A'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: order.orderItems
                          ?.map((item) => Text(
                        '${item.food?.name ?? 'Unknown'} (x${item.quantity ?? 0})',
                      ))
                          .toList() ??
                          [],
                    ),
                    Text(_getTotalQuantity(order).toString()),
                    Text('\$${order.totalPrice?.toStringAsFixed(2) ?? '0.00'}'),
                    Text(order.status ?? 'Pending'),
                    if (_isAdmin())
                      _isApproved(order)
                          ? Text(order.staff?.name ?? 'N/A')
                          : DropdownButton<int>(
                        isExpanded: true,
                        hint: Text('Assign Waiter'),
                        value: _selectedWaiters[order.id],
                        onChanged: (value) {
                          setState(() {
                            _selectedWaiters[order.id!] = value!;
                          });
                        },
                        items: _waiterList.map((waiter) {
                          return DropdownMenuItem<int>(
                            value: waiter.id,
                            child: Text(waiter.name ?? 'Unknown'),
                          );
                        }).toList(),
                      ),
                    if (_isAdmin() && !_isApproved(order))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _approveOrder(order.id!),
                            child: Text('Approve'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _rejectOrder(order.id!),
                            child: Text('Reject'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
