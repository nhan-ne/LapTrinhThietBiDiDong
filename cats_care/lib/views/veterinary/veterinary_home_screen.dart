import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/veterinary/veterinary_view_model.dart';
import '../appointment/add_address_screen.dart';
import 'veterinary_card.dart';
// ignore: unused_import
import '../delivery/add_address.dart'; // Import AddAppointmentScreen

class VeterinaryHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VeterinaryViewModel(),
      child: _VeterinaryHomePageContent(),
    );
  }
}

class _VeterinaryHomePageContent extends StatefulWidget {
  @override
  _VeterinaryHomePageContentState createState() => _VeterinaryHomePageContentState();
}

class _VeterinaryHomePageContentState extends State<_VeterinaryHomePageContent> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<VeterinaryViewModel>(context, listen: false);
    viewModel.loadVeterinaryData();
    viewModel.searchController.addListener(viewModel.onSearchChanged);
  }

  @override
  void dispose() {
    final viewModel = Provider.of<VeterinaryViewModel>(context, listen: false);
    viewModel.searchController.removeListener(viewModel.onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VeterinaryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thú y',
          style: TextStyle(fontSize: 24,color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xff7FDDE5),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextField(
                controller: viewModel.searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: Consumer<VeterinaryViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.filteredVeterinaryData.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                      children: viewModel.filteredVeterinaryData
                          .map((data) => VeterinaryCard(
                        name: data.name,
                        address: data.address,
                        phone: data.phone,
                        hours: data.hours,
                        image: data.image,
                        onBookAppointment: () {
                          Navigator.push( // Điều hướng đến AddAppointmentScreen
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAppointmentScreen(veterinaryName: data.name)
                            ),
                          );
                        },
                      ))
                          .toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}