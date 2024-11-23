import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

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

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    // Fetch the logo from the provided URL
    final logoUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYzO2AfjbzHrUwpBf8L0_JAT6qNW0i-1zVBg&s';
    final response = await http.get(Uri.parse(logoUrl));
    final logo = response.statusCode == 200 ? response.bodyBytes : null;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          if (logo != null)
            pw.Center(
              child: pw.Image(
                pw.MemoryImage(logo),
                width: 100,
                height: 100,
              ),
            ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text(
              'XYZ RESTAURANT',
              style: pw.TextStyle(fontSize: 25,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue,
              ),
            ),
          ),
          pw.Center(
            child: pw.Text(
              'Panthapath, Dhanmondi, Dhaka 1205',
              style: pw.TextStyle(fontSize: 14),
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Bill Details',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.teal),
          ),
          pw.SizedBox(height: 16),
          pw.Text('Bill ID: ${_bill?.id ?? 'N/A'}'),
          pw.Text('Total Amount: \$${_bill?.totalAmount?.toStringAsFixed(2) ?? '0.00'}'),
          pw.Text('Status: ${_bill?.status ?? 'Unknown'}'),
          pw.Text('Payment Method: ${_bill?.paymentMethod ?? 'N/A'}'),
          pw.Text('Bill Date: ${_bill?.billDate ?? 'N/A'}'),
          pw.SizedBox(height: 16),
          pw.Text(
            'Order Details',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.teal),
          ),
          pw.Divider(),
          if (_order != null && _order!.orderItems != null && _order!.orderItems!.isNotEmpty)
            pw.Column(
              children: _order!.orderItems!.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Item: ${item.food?.name ?? 'Unknown'}'),
                      pw.Text('Quantity: ${item.quantity ?? 0}'),
                      pw.Text('Price: \$${item.food?.price?.toStringAsFixed(2) ?? '0.00'}'),
                      pw.Text(
                        'Total: \$${((item.quantity ?? 0) * (item.food?.price ?? 0)).toStringAsFixed(2)}',
                        style: pw.TextStyle(color: PdfColors.green, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Divider(),
                    ],
                  ),
                );
              }).toList(),
            )
          else
            pw.Text('No items in the order.'),
          pw.SizedBox(height: 16),
          if (_bill?.paidBy != null)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'User Details',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.teal),
                ),
                pw.SizedBox(height: 8),
                pw.Text('Name: ${_bill?.paidBy?.name ?? 'N/A'}'),
                pw.Text('Email: ${_bill?.paidBy?.email ?? 'N/A'}'),
                pw.Text('Phone: ${_bill?.paidBy?.phone ?? 'N/A'}'),
              ],
            ),
          pw.SizedBox(height: 16),
          if (_bill?.receivedBy != null)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Admin Details',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.teal),
                ),
                pw.SizedBox(height: 8),
                pw.Text('Name: ${_bill?.receivedBy?.name ?? 'N/A'}'),
                pw.Text('Email: ${_bill?.receivedBy?.email ?? 'N/A'}'),
                pw.Text('Phone: ${_bill?.receivedBy?.phone ?? 'N/A'}'),
              ],
            ),
        ],
        footer: (pw.Context context) => pw.Center(
          child: pw.Text(
            'Thank you for choosing XYZ Restaurant! We hope to serve you again.',
            style: pw.TextStyle(fontSize: 15, color: PdfColors.blueGrey500),
          ),
        ),
      ),
    );

    return pdf.save();
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
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () async {
              final pdfData = await _generatePdf();
              await Printing.layoutPdf(onLayout: (format) => pdfData);
            },
          ),
        ],
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
    return Card(
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
            Text('Paid By: ${_bill?.paidBy?.name ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminDetails() {
    return Card(
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
            Text('Received By: ${_bill?.receivedBy?.name ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
