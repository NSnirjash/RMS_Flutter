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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(
          'Bill Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.amberAccent, size: 30,),
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
        child: Text(
          'No bill details available',
          style: TextStyle(fontSize: 18),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Bill Information', Icons.receipt),
              _buildBillInfo(),
              const SizedBox(height: 16),
              _buildSectionHeader('Order Details', Icons.shopping_cart),
              _buildOrderDetails(),
              const SizedBox(height: 16),
              _buildSectionHeader('User Details', Icons.person),
              _buildUserDetails(),
              const SizedBox(height: 16),
              _buildSectionHeader('Admin Details', Icons.admin_panel_settings),
              _buildAdminDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildBillInfo() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Bill ID', _bill?.id?.toString() ?? 'N/A'),
          _buildDetailRow('Total Amount', '\$${_bill?.totalAmount?.toStringAsFixed(2) ?? '0.00'}'),
          _buildDetailRow('Status', _bill?.status?.toString() ?? 'Unknown'),
          _buildDetailRow('Payment Method', _bill?.paymentMethod?.toString() ?? 'N/A'),
          _buildDetailRow('Bill Date', _bill?.billDate?.toString() ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    if (_order == null) {
      return const Text('No order details available.');
    }
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Order ID', _order?.id?.toString() ?? 'N/A'),
          _buildDetailRow('Total Price', '\$${_order?.totalPrice?.toStringAsFixed(2) ?? '0.00'}'),
          const SizedBox(height: 8),
          const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
          const SizedBox(height: 8),
          ...?_order?.orderItems?.map((item) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(item.food?.name?.toString() ?? 'Unknown'),
                subtitle: Text(
                  'Quantity: ${item.quantity?.toString() ?? '0'}, Price: \$${item.food?.price?.toStringAsFixed(2) ?? '0.00'}',
                ),
                trailing: Text(
                  'Total: \$${((item.quantity ?? 0) * (item.food?.price ?? 0)).toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }


  Widget _buildUserDetails() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Paid By', _bill?.paidBy?.name ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildAdminDetails() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Received By', _bill?.receivedBy?.name ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade100, Colors.teal.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

