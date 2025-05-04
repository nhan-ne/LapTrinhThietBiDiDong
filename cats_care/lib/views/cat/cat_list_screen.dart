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
        title: Text('Danh sách Mèo'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCatScreen()),
              );
            },
          ),
        ],
      ),
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
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedCat?.name ?? 'Chọn một con mèo',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.arrow_drop_down),
            onSelected: (int index) {
              setState(() {
                _selectedCat = viewModel.cats[index];
                _selectedCatIndex = index;
                _initializeControllers();
              });
            },
            itemBuilder: (BuildContext context) {
              return List<PopupMenuEntry<int>>.generate(
                viewModel.cats.length,
                    (int index) => PopupMenuItem<int>(
                  value: index,
                  child: Text(viewModel.cats[index].name ?? 'Không có tên'),
                ),
              );
            },
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _pickedImage != null
                      ? Image.file(File(_pickedImage!.path), fit: BoxFit.cover)
                      : _selectedCat!.imagePath != null
                      ? Image.file(
                    File(_selectedCat!.imagePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, object, stackTrace) =>
                        Center(child: Icon(Icons.error_outline)),
                  )
                      : Center(child: Icon(Icons.image)),
                ),
              ),
              SizedBox(height: 16.0),
              Text('Tên: ${_selectedCat!.name ?? 'Không có'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Giống: ${_selectedCat!.breed ?? 'Không có'}'),
              Text('Giới tính: ${_selectedCat!.gender ?? 'Không có'}'),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Ngày sinh',
                    hintText: 'Chọn ngày sinh',
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Chưa chọn'
                        : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                  ),
                ),
              ),
              TextFormField(
                controller:
                _weightControllers.isNotEmpty ? _weightControllers[0] : null,
                keyboardType:
                TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Cân nặng (kg)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập cân nặng';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Cân nặng phải là một số';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveCatChanges(viewModel);
                      }
                    },
                    child: Text('Lưu thay đổi'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(
                          context, viewModel, _selectedCatIndex);
                    },
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('Xóa', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
          title: const Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Bạn có chắc chắn muốn xóa thông tin của mèo ${viewModel.cats[index].name} không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa'),
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