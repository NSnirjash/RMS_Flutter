import 'package:flutter/material.dart';
import 'package:rms_flutter/model/table.dart';
import 'package:rms_flutter/page/AdminPage.dart';
import 'package:rms_flutter/page/AllTableViewPage.dart';
import 'package:rms_flutter/service/TableService.dart';

class AddTablePage extends StatefulWidget {
  const AddTablePage({super.key});

  @override
  State<AddTablePage> createState() => _AddTablePageState();
}

class _AddTablePageState extends State<AddTablePage> {

  final _formKey = GlobalKey<FormState>();
  final TableService _tableService = TableService();

  // Controllers for form fields
  final TextEditingController _tableNumberController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  String _selectedStatus = 'AVAILABLE';

  Future<void> _saveTable() async {
    if (_formKey.currentState!.validate()) {
      final table = TableModel(
        tableNumber: _tableNumberController.text,
        capacity: int.tryParse(_capacityController.text),
        status: _selectedStatus,
      );

      try {
        await _tableService.createTable(table);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Table added successfully!')),
        );

        // Clear form fields after saving
        _tableNumberController.clear();
        _capacityController.clear();
        setState(() => _selectedStatus = 'AVAILABLE');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add table: $e')),
        );
      }
    }
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
              MaterialPageRoute(builder: (context) => AllTableViewPage()),
            );
          },
        ),
        title: Text('Add New Table', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Enter Table Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _tableNumberController,
                decoration: InputDecoration(
                  labelText: 'Table Number',
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Icon(Icons.table_chart, color: Colors.teal),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter table number' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Capacity',
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Icon(Icons.people, color: Colors.teal),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter capacity' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: ['AVAILABLE', 'PENDING', 'BOOKED']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedStatus = value!),
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Icon(Icons.info, color: Colors.teal),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveTable,
                icon: Icon(Icons.save, color: Colors.white),
                label: Text('Save Table'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

