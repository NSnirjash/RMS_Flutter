
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:rms_flutter/model/food.dart';
import 'package:rms_flutter/page/AdminPage.dart';
import 'package:rms_flutter/page/FoodListPage.dart';
import 'package:rms_flutter/service/FoodService.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage; // Use XFile for consistency with image_picker
  Uint8List? webImage; // To hold image data as Uint8List

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool _isAvailable = true;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // For Web: Use image_picker_web to pick image and store as bytes
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage;
        });
      }
    } else {
      // For Mobile: Use image_picker to pick image
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  Future<void> _saveFood() async {
    if (_formKey.currentState!.validate() && (selectedImage != null || webImage != null)) {
      // Prepare food data
      final food = {
        'name': _nameController.text,
        'price': _priceController.text,
        'category': _categoryController.text,
        'available': _isAvailable,
      };

      var uri = Uri.parse('http://localhost:8090/api/food/save');
      var request = http.MultipartRequest('POST', uri);

      // Add food data as JSON
      request.files.add(
        http.MultipartFile.fromString(
          'food',
          jsonEncode(food),
          contentType: MediaType('application', 'json'),
        ),
      );

      if (kIsWeb && webImage != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          webImage!,
          filename: 'upload.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          selectedImage!.path,
        ));
      }

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Food added successfully!')),
          );
          _clearForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add food. Status code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error occurred while submitting: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while adding food.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and upload an image.')),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _categoryController.clear();

    setState(() {
      selectedImage = null;
      webImage = null;
      _isAvailable = true;
    });
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
                MaterialPageRoute(builder: (context) => FoodListPage()),
            );
          },
        ),
        title: Text(
          'Add New Food',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.teal.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Food Name',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
                            ),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Enter food name' : null,
                        ),
                        SizedBox(height: 16),

                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
                            ),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Enter price' : null,
                        ),
                        SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _categoryController.text.isEmpty ? null : _categoryController.text,
                          items: ['Fast Food', 'Main Course', 'Dessert', 'Drinks']
                              .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _categoryController.text = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Category',
                            labelStyle: TextStyle(color: Colors.teal.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
                            ),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Select a category' : null,
                        ),
                        SizedBox(height: 16),
                        SwitchListTile(
                          title: Text(
                            'Available',
                            style: TextStyle(color: Colors.teal.shade700),
                          ),
                          value: _isAvailable,
                          onChanged: (value) => setState(() => _isAvailable = value),
                          contentPadding: EdgeInsets.zero,
                          activeColor: Colors.teal.shade700,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                OutlinedButton.icon(
                  icon: Icon(Icons.image, color: Colors.teal.shade600),
                  label: Text('Upload Image', style: TextStyle(color: Colors.teal.shade600)),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    side: BorderSide(color: Colors.teal.shade600, width: 1.5),
                  ),
                  onPressed: _pickImage,
                ),
                if (kIsWeb && webImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(
                      webImage!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                else if (!kIsWeb && selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(selectedImage!.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),

                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveFood,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.teal.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Save Food',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
