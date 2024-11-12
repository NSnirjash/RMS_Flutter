
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rms_flutter/model/food.dart';
import 'package:rms_flutter/service/FoodService.dart';
import 'dart:typed_data';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile; // Use XFile for consistency with image_picker
  Uint8List? _imageData; // To hold image data as Uint8List

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool _isAvailable = true;

  Future<void> _pickImage() async{
    try{
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if(pickedFile != null){
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = pickedFile;
          _imageData = bytes;
        });
      }
    }catch(e){
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Picking Image ${e.toString()}')),
      );
    }
  }

  Future<void> _saveFood() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final food = Food(
        id: 0,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        category: _categoryController.text,
        available: _isAvailable,
        image: '', // Will be handled by backend
      );

      try {
        await FoodService().createFood(food, _imageFile!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Food added successfully!')),
        );

        // Clear form fields and reset image
        _nameController.clear();
        _priceController.clear();
        _categoryController.clear();
        _imageFile = null;
        _imageData = null;
        setState(() {});
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding food: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and upload an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Food'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
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
                color: Colors.teal[50], // Light teal background for the card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Food Name',
                          labelStyle: TextStyle(color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal, width: 2),
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
                          labelStyle: TextStyle(color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal, width: 2),
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
                          labelStyle: TextStyle(color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal, width: 2),
                          ),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Select a category' : null,
                      ),
                      SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(
                          'Available',
                          style: TextStyle(color: Colors.teal[800]),
                        ),
                        value: _isAvailable,
                        onChanged: (value) => setState(() => _isAvailable = value),
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton.icon(
                icon: Icon(Icons.image, color: Colors.teal),
                label: Text('Upload Image', style: TextStyle(color: Colors.teal)),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  side: BorderSide(color: Colors.teal, width: 1.5),
                ),
                onPressed: _pickImage,
              ),
              if (_imageData != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(_imageData!, height: 150, fit: BoxFit.cover),
                  ),
                ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveFood,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.teal, // Button color
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
    );
  }
}
