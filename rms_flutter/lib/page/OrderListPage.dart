import 'package:flutter/material.dart';
import 'package:rms_flutter/model/Order.dart';
import 'package:rms_flutter/model/user.dart';
import 'package:rms_flutter/page/AdminPage.dart';
import 'package:rms_flutter/page/BillDetailsPage.dart';
import 'package:rms_flutter/page/UserPage.dart';
import 'package:rms_flutter/service/AuthService.dart';
import 'package:rms_flutter/service/OrderService.dart';
import 'package:rms_flutter/service/BillService.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();
  final BillService _billService = BillService();

  List<OrderModel> _orderList = [];
  List<User> _waiterList = [];
  User? _currentUser;
  Map<int, int> _selectedWaiters = {};

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
        // Sort orders by ID in descending order (new to old)
        _orderList = orders..sort((a, b) => b.id!.compareTo(a.id!));
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

  void _createBill(int orderId) async {
    if (_isAdmin()) {
      final bill = await _billService.createBill(orderId, _currentUser!.id!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Bill created successfully with ID: ${bill.id}')));
      _loadOrderList();
    }
  }

  void _payBill(int billId) async {
    final bill = await _billService.payBill(billId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bill paid successfully. Status changed to GIVEN.')));
    _loadOrderList();
  }

  void _confirmBill(int billId) async {
    final bill = await _billService.confirmBill(billId, _currentUser!.id!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bill confirmed successfully. Status changed to PAID.')));
    _loadOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (_isAdmin()) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminPage()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserPage()),
              );
            }
          },
        ),
        title: Text('Food Order List',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.teal[200], // Page background color
        child: _orderList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: _orderList.length,
                itemBuilder: (context, index) {
                  final order = _orderList[index];
                  return Card(
                    elevation: 6,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        gradient: LinearGradient(
                          colors: [
                            Colors.tealAccent.shade100,
                            Colors.lightBlueAccent.shade100
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order #${order.id}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                                Text(
                                  order.status ?? 'Pending',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: order.status == 'APPROVED'
                                        ? Colors.green
                                        : (order.status == 'REJECTED'
                                            ? Colors.red
                                            : Colors.orange),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.black45),
                            Text(
                              'Items:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            ...order.orderItems?.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      '${item.food?.name ?? 'Unknown'} x${item.quantity ?? 0}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList() ??
                                [],
                            SizedBox(height: 8.0),
                            Text(
                              'Total Quantity: ${_getTotalQuantity(order)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              'Total Price: \$${order.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Bill Status: ${order.bill != null ? order.bill!.status ?? "N/A" : "No Bill"}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: order.bill != null
                                    ? (order.bill!.status == 'PAID'
                                    ? Colors.green
                                    : (order.bill!.status == 'UNPAID'
                                    ? Colors.red
                                    : (order.bill!.status == 'GIVEN' ? Colors.orange : Colors.black)))
                                    : Colors.black,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            if (_isAdmin() && !_isApproved(order))
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButton<int>(
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
                                  ),
                                  SizedBox(width: 8.0),
                                  ElevatedButton(
                                    onPressed: () => _approveOrder(order.id!),
                                    child: Text('Approve',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        )),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  ElevatedButton(
                                    onPressed: () => _rejectOrder(order.id!),
                                    child: Text('Reject',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        )),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            if (_isAdmin() && _isApproved(order))
                              Text(
                                'Assigned to: ${order.staff?.name ?? 'N/A'}',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            SizedBox(height: 12.0),
                            if (_isAdmin() &&
                                _isApproved(order) &&
                                order.bill == null)
                              ElevatedButton(
                                onPressed: () => _createBill(order.id!),
                                child: Text('Create Bill'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  textStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (_isAdmin() &&
                                order.status == 'APPROVED' &&
                                order.bill != null &&
                                order.bill!.status == 'GIVEN')
                              ElevatedButton(
                                onPressed: () => _confirmBill(order.bill!.id!),
                                child: Text('Confirm Bill'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan,
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (!_isAdmin() &&
                                order.bill != null &&
                                order.bill!.status == 'UNPAID')
                              ElevatedButton(
                                onPressed: () => _payBill(order.bill!.id!),
                                child: Text('Pay Bill'),
                              ),
                            if (order.bill != null &&
                                order.bill!.status == 'PAID')
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BillDetailsPage(
                                          billId: order.bill!.id!),
                                    ),
                                  );
                                },
                                child: Text('View Bill'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  textStyle:
                                      TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87
                                      ),
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
    );
  }
}
