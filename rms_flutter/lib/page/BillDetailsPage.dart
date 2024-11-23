import 'package:flutter/material.dart';
import 'package:rms_flutter/model/Bill.dart';
import 'package:rms_flutter/model/Order.dart';
import 'package:rms_flutter/page/AdminPage.dart';
import 'package:rms_flutter/service/BillService.dart';
import 'package:rms_flutter/service/OrderService.dart';

class BillDetailsPage extends StatefulWidget {
  final int billId;

  const BillDetailsPage({Key? key, required this.billId}) : super(key: key);

  @override
  State<BillDetailsPage> createState() => _BillDetailsPageState();
}

class _BillDetailsPageState extends State<BillDetailsPage> {
  BillModel? _bill;
  OrderModel? _order;
  bool _isLoading = true;
  final BillService _billService = BillService();
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _loadBillDetails();
  }

  Future<void> _loadBillDetails() async {
    try {
      final bill = await _billService.getBillById(widget.billId);
      setState(() {
        _bill = bill;
      });
      if (bill.id != null) {
        await _loadOrderDetails(bill.id!);
      }
    } catch (error) {
      _showErrorSnackBar('Failed to load bill details');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadOrderDetails(int billId) async {
    try {
      final order = await _orderService.getOrderByBillId(billId);
      setState(() {
        _order = order;
      });
    } catch (error) {
      _showErrorSnackBar('Failed to load order details');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
        title: const Text('Bill Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _bill == null
          ? const Center(
        child: Text('No bill details available'),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBillInfo(),
              const SizedBox(height: 16),
              _buildOrderDetails(),
              const SizedBox(height: 16),
              _buildUserDetails(),
              const SizedBox(height: 16),
              _buildAdminDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillInfo() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bill Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Bill ID: ${_bill?.id ?? 'N/A'}'),
            Text('Total Amount: \$${_bill?.totalAmount?.toStringAsFixed(2) ?? '0.00'}'),
            Text('Status: ${_bill?.status ?? 'Unknown'}'),
            Text('Payment Method: ${_bill?.paymentMethod ?? 'N/A'}'),
            Text('Bill Date: ${_bill?.billDate ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return _order == null
        ? const Text('No order details available.')
        : Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Order ID: ${_order?.id ?? 'N/A'}'),
            Text('Total Price: \$${_order?.totalPrice?.toStringAsFixed(2) ?? '0.00'}'),
            const SizedBox(height: 8),
            const Text('Items:'),
            _order?.orderItems != null && _order!.orderItems!.isNotEmpty
                ? Column(
              children: _order!.orderItems!.map((item) {
                return ListTile(
                  title: Text(item.food?.name ?? 'Unknown'),
                  subtitle: Text(
                    'Quantity: ${item.quantity ?? 0}, Price: \$${item.food?.price?.toStringAsFixed(2) ?? '0.00'}',
                  ),
                  trailing: Text(
                    'Total: \$${((item.quantity ?? 0) * (item.food?.price ?? 0)).toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                );
              }).toList(),
            )
                : const Text('No items in the order.'),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetails() {
    final user = _bill?.paidBy;
    return user == null
        ? const Text('No user details available.')
        : Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Paid By: ${user.name ?? 'N/A'}'),
            Text('Contact: ${user.phone ?? 'N/A'}'),
            Text('Email: ${user.email ?? 'N/A'}'),
            Text('Address: ${user.address ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminDetails() {
    final admin = _bill?.receivedBy;
    return admin == null
        ? const Text('No admin details available.')
        : Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Received By: ${admin.name ?? 'N/A'}'),
            Text('Contact: ${admin.phone ?? 'N/A'}'),
            Text('Email: ${admin.email ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
