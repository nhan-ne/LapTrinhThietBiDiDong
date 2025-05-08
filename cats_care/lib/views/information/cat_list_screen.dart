import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cat_information_model.dart';
import '../../viewmodels/information/cat_list_view_model.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'cat_information_screen.dart';

class CatListScreen extends StatefulWidget {
  @override
  _CatListScreenState createState() => _CatListScreenState();
}

class _CatListScreenState extends State<CatListScreen> {
  final _formKey = GlobalKey<FormState>();
  Cat? _selectedCat;
  int _selectedCatIndex = 0;
  List<TextEditingController> _weightControllers = [];
  DateTime? _selectedDate;
  XFile? _pickedImage;
  bool _isImageHovered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<CatListViewModel>(context, listen: false);
    if (viewModel.cats.isNotEmpty) {
      _selectedCat = viewModel.cats[0];
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    if (_selectedCat != null) {
      _weightControllers = [
        TextEditingController(text: _selectedCat!.weight?.toString() ?? '')
      ];
      _selectedDate = _selectedCat!.dateOfBirth;
    } else {
      _weightControllers = [TextEditingController()];
      _selectedDate = null;
    }
    _pickedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
        'Thông tin mèo',
          style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff7FDDE5),
        elevation: 0,
        centerTitle: true,
        leading: IconButton( // Thêm nút back
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCatScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.lightBlue[50],
      body: Consumer<CatListViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.cats.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AddCatScreen()),
              );
            });
            return Center(child: Text('Không có con mèo nào.'));
          }

          return Column(
            children: [
              _buildCatSelectionDropdown(viewModel),
              Expanded(
                child: _buildCatDetails(viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCatSelectionDropdown(CatListViewModel viewModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedCat?.name ?? 'Chọn một con mèo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          DropdownButton<int>(
            value: _selectedCatIndex,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black87),
            underline: Container(
              height: 2,
              color: Colors.lightBlue,
            ),
            onChanged: (int? index) {
              setState(() {
                _selectedCat = viewModel.cats[index!];
                _selectedCatIndex = index;
                _initializeControllers();
              });
            },
            items: viewModel.cats.map<DropdownMenuItem<int>>((Cat cat) {
              return DropdownMenuItem<int>(
                value: viewModel.cats.indexOf(cat),
                child: Text(cat.name ?? 'Không có tên'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCatDetails(CatListViewModel viewModel) {
    if (_selectedCat == null) {
      return Center(child: Text('Vui lòng chọn một con mèo'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCatImage(),
                  SizedBox(height: 16.0),
                  _buildCatInfo(),
                  SizedBox(height: 16.0),
                  _buildWeightInput(),
                  SizedBox(height: 16.0),
                  _buildActionButtons(viewModel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCatImage() {
    return GestureDetector(
      onTap: _pickImage,
      onTapDown: (_) => setState(() => _isImageHovered = true),
      onTapCancel: () => setState(() => _isImageHovered = false),
      onTapUp: (_) => setState(() => _isImageHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isImageHovered ? 1.05 : 1.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: 200,
        width: double.infinity,
        child: _pickedImage != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
        )
            : _selectedCat!.imagePath != null
            ? File(_selectedCat!.imagePath!).existsSync()
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.file(
            File(_selectedCat!.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Center(child: Icon(Icons.broken_image)),
          ),
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/placeholder.png',
            image: _selectedCat!.imagePath!,
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) =>
                Center(child: Icon(Icons.broken_image)),
          ),
        )
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildCatInfo() {
    return ExpansionTile(
      title: Text("Thông tin chung", style: TextStyle(fontWeight: FontWeight.bold)),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Tên: ${_selectedCat!.name ?? 'Không có'}'),
        ),
        ListTile(
          leading: Icon(Icons.cake),
          title: Text(
              'Ngày sinh: ${_selectedDate == null ? 'Chưa chọn' : DateFormat('dd/MM/yyyy').format(_selectedDate!)}'),
        ),
        ListTile(
          leading: Icon(Icons.category),
          title: Text('Giống: ${_selectedCat!.breed ?? 'Không có'}'),
        ),
        ListTile(
          leading: Icon(
              Icons.transgender),
          title: Text('Giới tính: ${_selectedCat!.gender ?? 'Không có'}'),
        ),
      ],
    );
  }

  Widget _buildWeightInput() {
    return TextFormField(
      controller:
      _weightControllers.isNotEmpty ? _weightControllers[0] : null,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Cân nặng (kg)',
        prefixIcon: Icon(Icons.scale),
        hintText: 'Nhập cân nặng của mèo',
        labelStyle: TextStyle(color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập cân nặng';
        }
        if (double.tryParse(value) == null) {
          return 'Cân nặng phải là một số';
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons(CatListViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _saveCatChanges(viewModel);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 4.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.save),
              SizedBox(width: 8.0),
              Text('Lưu'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _showDeleteConfirmationDialog(
                context, viewModel, _selectedCatIndex);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 4.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8.0),
              Text('Xóa'),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _pickedImage = pickedFile;
      }
    });
  }

  // ignore: unused_element
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveCatChanges(CatListViewModel viewModel) async {
    if (_selectedCat == null) return;

    final newWeight = double.tryParse(_weightControllers[0].text);
    final newDateOfBirth = _selectedDate;
    String? newImagePath = _selectedCat!.imagePath;

    if (_pickedImage != null) {
      newImagePath = _pickedImage!.path;
    }

    if (newWeight != null || newDateOfBirth != null || newImagePath != null) {
      await viewModel.updateCat(
          _selectedCat!.id!, newWeight, newDateOfBirth, newImagePath);

      print('Thông tin mèo đã được cập nhật');
      print('Ảnh đã được lưu tại: $newImagePath');
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, CatListViewModel viewModel, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          contentTextStyle: TextStyle(color: Colors.black87, fontSize: 16),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8.0),
              Text('Xác nhận xóa'),
            ],
          ),
          content: Text(
              'Bạn có chắc chắn muốn xóa thông tin của mèo ${viewModel
                  .cats[index].name} không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () {
                viewModel.deleteCat(viewModel.cats[index].id!);
                Navigator.of(context).pop();
                setState(() {
                  _selectedCat = null;
                  _initializeControllers();
                });
              },
            ),
          ],
        );
      },
    );
  }
}