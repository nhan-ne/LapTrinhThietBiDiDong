import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cathotel/cat_hotel_view_model.dart';
import '../bookinghotel/add_booking_screen.dart';
import 'cat_hotel_card.dart';

class CatHotelHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CatHotelViewModel(),
      child: _CatHotelHomePageContent(),
    );
  }
}

class _CatHotelHomePageContent extends StatefulWidget {
  @override
  _CatHotelHomePageContentState createState() => _CatHotelHomePageContentState();
}

class _CatHotelHomePageContentState extends State<_CatHotelHomePageContent> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<CatHotelViewModel>(context, listen: false);
    viewModel.loadCatHotelData();
    viewModel.searchController.addListener(viewModel.onSearchChanged);
  }

  @override
  void dispose() {
    final viewModel = Provider.of<CatHotelViewModel>(context, listen: false);
    viewModel.searchController.removeListener(viewModel.onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CatHotelViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Khách sạn mèo',
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
              child: Consumer<CatHotelViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.filteredCatHotelData.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                      children: viewModel.filteredCatHotelData
                          .map((data) => CatHotelCard(
                        name: data.name,
                        address: data.address,
                        phone: data.phone,
                        services: data.services,
                        image: data.image,
                        onBook: () {
                          print('Đặt chỗ ở ${data.name}');
                          // Navigate to AddBookingScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBookingScreen(hotelName: data.name),
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