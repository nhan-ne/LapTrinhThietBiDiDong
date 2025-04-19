import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _addPet() {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _breedController.text.isEmpty ||
        _colorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    // Xử lý thêm thú cưng (ví dụ: lưu vào cơ sở dữ liệu)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm thú cưng'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              label: 'Tên thú cưng',
              controller: _nameController,
            ),
            _buildTextField(
              label: 'Tuổi thú cưng',
              controller: _ageController,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              label: 'Cân nặng thú cưng',
              controller: _weightController,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              label: 'Giống thú cưng',
              controller: _breedController,
            ),
            _buildTextField(
              label: 'Màu sắc thú cưng',
              controller: _colorController,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff10A37F)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage == null
                    ? const Center(
                        child: Text(
                          'Chọn ảnh thú cưng',
                          style: TextStyle(color: Color(0xff616161)),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff10A37F),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Thêm thú cưng',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField({
  required String label,
  required TextEditingController controller,
  TextInputType? keyboardType,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff10A37F)),
        ),
      ),
    ),
  );
}