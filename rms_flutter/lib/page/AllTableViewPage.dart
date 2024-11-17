import 'package:flutter/material.dart';
import 'package:rms_flutter/page/AddTablePage.dart';
import 'package:rms_flutter/page/AdminPage.dart';
import 'package:rms_flutter/service/TableService.dart';
import 'package:rms_flutter/model/table.dart';

class AllTableViewPage extends StatefulWidget {
  const AllTableViewPage({Key? key}) : super(key: key);

  @override
  _AllTableViewPageState createState() => _AllTableViewPageState();
}

class _AllTableViewPageState extends State<AllTableViewPage> {
  final TableService _tableService = TableService();
  List<TableModel> _tables = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTables();
  }

  // Fetch all tables from the service
  Future<void> _fetchTables() async {
    try {
      final tables = await _tableService.fetchTables();
      setState(() {
        _tables = tables;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tables: $e')),
      );
    }
  }

  // Delete a table
  Future<void> _deleteTable(int id) async {
    try {
      final success = await _tableService.deleteTable(id);
      if (success) {
        setState(() => _tables.removeWhere((table) => table.id == id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Table deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete table')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting table: $e')),
      );
    }
  }

  // Refresh list after updating or creating a table
  Future<void> _refreshTableList() async {
    setState(() => _isLoading = true);
    await _fetchTables();
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'AVAILABLE':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'BOOKED':
        return Colors.red;
      default:
        return Colors.grey;
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
              MaterialPageRoute(builder: (context) => AdminPage()),
            );
          },
        ),
        title: Text('All Tables', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshTableList,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.teal))
            : ListView.builder(
          itemCount: _tables.length,
          itemBuilder: (context, index) {
            final table = _tables[index];
            return Card(
              color: Colors.white,
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.1),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    table.tableNumber ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  'Table ${table.tableNumber}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      'Capacity: ${table.capacity ?? 'N/A'}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          table.status ?? 'Unknown',
                          style: TextStyle(color: _getStatusColor(table.status)),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Navigate to edit page
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTable(table.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade700,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTablePage()),
          ).then((_) => _refreshTableList());
        },
      ),
    );
  }
}
