import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/information/cat_information_view_model.dart';
import '../../viewmodels/information/cat_list_view_model.dart';
import 'cat_list_screen.dart'; // Import CatListScreen

class AddCatScreen extends StatefulWidget {
  @override
  _AddCatScreenState createState() => _AddCatScreenState();
}

class _AddCatScreenState extends State<AddCatScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AddCatViewModel>(context); // <-- Lấy ViewModel từ Provider
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Thông tin thú cưng',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff7FDDE5),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Consumer<AddCatViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                    key:_formKey,
                    child: Column(
                      children: [
                        _buildTitle('TÊN THÚ CƯNG'),
                        TextFormField(
                          controller: viewModel.nameController,
                          decoration: InputDecoration(
                              hintText: 'VD: Bim',
                              hintStyle: TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontWeight: FontWeight.w500),
                              border:OutlineInputBorder()
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên thú cưng' : null,
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn chỉnh các Column theo trục dọc
                          children: [
                            Expanded( // Đảm bảo Column đầu tiên chiếm không gian hợp lý
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTitle('GIỐNG'),
                                  TextFormField(
                                    controller: viewModel.breedController,
                                    decoration: InputDecoration(
                                      hintText: 'Giống',
                                      hintStyle: TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontWeight: FontWeight.w500),
                                      border: OutlineInputBorder(),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    validator: (value) => value!.isEmpty ? 'Vui lòng nhập giống' : null,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded( // Đảm bảo Column thứ hai chiếm không gian hợp lý
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTitle("GIỚI TINH"),
                                  DropdownButtonFormField<String>(
                                      value: viewModel.selectedGender,
                                      items: <String>['Đực', 'Cái']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: viewModel.selectGender,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      hint: Text('Chọn ',
                                        style: TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontWeight: FontWeight.w500),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        _buildTitle("NGÀY SINH"),
                        InkWell(
                          onTap: () => viewModel.selectDate(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                                hintText: 'Chọn ngày sinh',
                                hintStyle: TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontWeight: FontWeight.w500),
                                border: OutlineInputBorder()
                            ),
                            child: Text(
                              viewModel.selectedDate == null
                                  ? 'Chọn ngày sinh'
                                  : '${viewModel.selectedDate!.day}/${viewModel.selectedDate!.month}/${viewModel.selectedDate!.year}',
                              style: TextStyle(
                                color: viewModel.selectedDate == null
                                    ? Color(0xff9C9C9C)
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildTitle('CÂN NẶNG (KG)'),
                        TextFormField(
                          controller: viewModel.weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'VD: 5',
                            hintStyle: TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên thú cưng' : null,
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTitle('HÌNH ẢNH'),
                            InkWell(
                              onTap: viewModel.pickImage,
                              child: Container(
                                height: 120,
                                width: 140,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: viewModel.pickedImage == null
                                    ? Icon(Icons.add_a_photo, size: 20)
                                    : Image.file(File(viewModel.pickedImage!.path),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xff7FDDE5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? true) {
              final viewModel = Provider.of<AddCatViewModel>(context, listen: false);
              await viewModel.saveCat();
              // Check if the cat list is now non-empty
              final catListViewModel =
              Provider.of<CatListViewModel>(context,
                  listen: false);
              if (catListViewModel.cats.isNotEmpty) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CatListScreen()),
                );
              }
            }
          },
          child: Text('Lưu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,),
          ),
        ),
      ),
    );
  }
}

Widget _buildTitle(String title) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xff7FDDE5),
      ),
    ),
  );
}