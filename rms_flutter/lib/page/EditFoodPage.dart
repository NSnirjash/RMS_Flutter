import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rms_flutter/model/food.dart';
import 'package:rms_flutter/service/FoodService.dart';
import 'package:rms_flutter/service/AuthService.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';

class EditFoodPage extends StatefulWidget {
  final Food food;


  const EditFoodPage({super.key, required this.food});

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final FoodService _foodService= FoodService();
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;
  Uint8List? webImage; // To hold image data as Uint8List

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();

    // Prepopulate the form with the current food details
    _nameController.text = widget.food.name!;
    _priceController.text = widget.food.price.toString();
    _categoryController.text = widget.food.category!;
    _isAvailable = widget.food.available!;
  }

  // Future<void> _pickImage() async {
  //   if (kIsWeb) {
  //     var pickedImage = await ImagePickerWeb.getImageAsBytes();
  //     if (pickedImage != null) {
  //       setState(() {
  //         webImage = pickedImage;
  //       });
  //     }
  //   } else {
  //     final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
  //     if (pickedImage != null) {
  //       setState(() {
  //         selectedImage = pickedImage;
  //       });
  //     }
  //   }
  // }

  Future<void> pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  Future<void> _updateFood() async {
    if (_formKey.currentState!.validate()) {
      // Prepare the updated food data
      final food = Food(
        id: widget.food.id, // Preserve the original food ID
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        category: _categoryController.text,
        available: _isAvailable,
        image: selectedImage?.path ?? widget.food.image, // Keep the existing image unless updated
      );

      FoodService foodService = FoodService();

      await foodService.editFood(food,widget.food.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food updated successfully!')),
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
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text('Edit Food', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Enter price' : null,
                        ),
                        SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _categoryController.text.isEmpty
                              ? null
                              : _categoryController.text,
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
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Select a category' : null,
                        ),
                        SizedBox(height: 16),
                        SwitchListTile(
                          title: Text('Available', style: TextStyle(color: Colors.teal.shade700)),
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
                  onPressed: pickImage,
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
                else if (selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(selectedImage!.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                else if (widget.food.image != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        widget.food.image!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),

                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateFood,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.teal.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
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
