import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/bookinghotel/booking_view_model.dart';
import 'add_booking_screen.dart';

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Đặt Chỗ'),
      ),
      body: Consumer<BookingViewModel>(
        builder: (context, bookingViewModel, child) {
          return FutureBuilder(
            future: bookingViewModel.getBookings(),
            builder: (context, AsyncSnapshot<List<Booking>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Không có đặt chỗ nào.'));
              } else {
                final bookings = snapshot.data!;
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Tên khách hàng: ${booking.customerName}'),
                            Text('Tên mèo: ${booking.catName}'),
                            Text('Giống mèo: ${booking.breed}'),
                            Text('Ngày nhận phòng: ${DateFormat('dd/MM/yyyy').format(booking.checkInDate)}'),
                            Text('Ngày trả phòng: ${DateFormat('dd/MM/yyyy').format(booking.checkOutDate)}'),
                            Text('Loại phòng: ${booking.roomType}'),
                            if (booking.notes.isNotEmpty) Text('Ghi chú: ${booking.notes}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // TODO: Implement chức năng chỉnh sửa đặt chỗ
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    bookingViewModel.deleteBooking(booking.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookingScreen()),
          );
        },
        tooltip: 'Thêm Đặt Chỗ',
        child: const Icon(Icons.add),
      ),
    );
  }
}