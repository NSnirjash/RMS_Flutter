import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final TextEditingController _availableController = TextEditingController();

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
    }catch (e){
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Picking Image ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
