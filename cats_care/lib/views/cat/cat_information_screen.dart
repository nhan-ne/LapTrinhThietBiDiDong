import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/viewmodels/cat/cat_information_view_model.dart';
import '/viewmodels/cat/cat_list_view_model.dart'; // Import CatListViewModel
import 'cat_list_screen.dart'; // Import CatListScreen

class AddCatScreen extends StatefulWidget {
  @override
  _AddCatScreenState createState() => _AddCatScreenState();
}

class _AddCatScreenState extends State<AddCatScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddCatViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thông tin thú cưng'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Consumer<AddCatViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: viewModel.nameController,
                    decoration: InputDecoration(labelText: 'Tên thú cưng'),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: viewModel.breedController,
                    decoration: InputDecoration(labelText: 'Giống'),
                  ),
                  SizedBox(height: 16.0),
                  InkWell(
                    onTap: () => viewModel.selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Ngày sinh',
                        hintText: 'Chọn ngày sinh',
                      ),
                      child: Text(
                        viewModel.selectedDate == null
                            ? ''
                            : '${viewModel.selectedDate!.day}/${viewModel.selectedDate!.month}/${viewModel.selectedDate!.year}',
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      Text('Giới tính:'),
                      SizedBox(width: 16.0),
                      Radio<String>(
                        value: 'Đực',
                        groupValue: viewModel.selectedGender,
                        onChanged: viewModel.selectGender,
                      ),
                      Text('Đực'),
                      Radio<String>(
                        value: 'Cái',
                        groupValue: viewModel.selectedGender,
                        onChanged: viewModel.selectGender,
                      ),
                      Text('Cái'),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: viewModel.weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Cân nặng (kg)'),
                  ),
                  SizedBox(height: 16.0),
                  InkWell(
                    onTap: viewModel.pickImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: viewModel.pickedImage == null
                          ? Center(child: Text('Chọn ảnh'))
                          : Image.file(File(viewModel.pickedImage!.path),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? true) {
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
                    child: Text('Lưu'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}