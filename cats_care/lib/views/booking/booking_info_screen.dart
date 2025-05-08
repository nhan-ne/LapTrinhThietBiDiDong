import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/booking.dart';
import '../../models/Appointment.dart';
import '../../viewmodels/appointment/appointment_view_model.dart';
import '../../viewmodels/bookinghotel/booking_view_model.dart';
import '../veterinary/veterinary_home_screen.dart';
import '../cathotel/cat_hotel_home_screen.dart';

class BookingInfoScreen extends StatelessWidget {
  const BookingInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin đặt lịch',
          style: TextStyle(fontSize: 24,color: Colors.white),),
        backgroundColor: const Color(0xff7FDDE5),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.blue[50],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Khách Sạn Mèo', Icons.hotel),
              const SizedBox(height: 16),
              _buildCatHotelBookings(context),
              const SizedBox(height: 32),
              _buildSectionTitle('Lịch Khám Thú Y', Icons.local_hospital),
              const SizedBox(height: 16),
              _buildVeterinaryAppointments(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xff7FDDE5)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xff7FDDE5),
          ),
        ),
      ],
    );
  }

  Widget _buildCatHotelBookings(BuildContext context) {
    return Consumer<BookingViewModel>(
      builder: (context, bookingViewModel, child) {
        return FutureBuilder(
          future: bookingViewModel.getBookings(),
          builder: (context, AsyncSnapshot<List<Booking>> snapshot) {
            print("Snapshot data: ${snapshot.data}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else {
              final bookings = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bookings.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) => _buildCatHotelBookingCard(context, bookings[index]),
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                    ),
                  if (bookings.isEmpty) // Thêm đoạn này để hiển thị thông báo khi không có dữ liệu
                    const Center(child: Text("Không có đặt phòng khách sạn mèo nào.")),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CatHotelHomePage()),
                      );
                    },
                    icon: const Icon(Icons.hotel, color: Colors.white),
                    label: const Text('Đến Khách Sạn Mèo', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff7FDDE5),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _buildCatHotelBookingCard(BuildContext context, Booking booking) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          '${booking.customerName} - ${booking.catName}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text('Ngày nhận: ${DateFormat('dd/MM/yyyy').format(booking.checkInDate)}'),
        childrenPadding: const EdgeInsets.all(16),
        children: <Widget>[
          _buildInfoRow('Khách sạn mèo', booking.hotelName),
          _buildInfoRow('Điện thoại', booking.phone),
          _buildInfoRow('Giống mèo', booking.breed),
          _buildInfoRow('Ngày nhận phòng', DateFormat('dd/MM/yyyy').format(booking.checkInDate)),
          _buildInfoRow('Ngày trả phòng', DateFormat('dd/MM/yyyy').format(booking.checkOutDate)),
          _buildInfoRow('Loại phòng', booking.roomType),
          if (booking.notes.isNotEmpty) _buildInfoRow('Ghi chú', booking.notes),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, 'bookinghotel', booking.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVeterinaryAppointments(BuildContext context) {
    return Consumer<AppointmentViewModel>(
      builder: (context, appointmentViewModel, child) {
        return FutureBuilder(
          future: appointmentViewModel.getAppointments(),
          builder: (context, AsyncSnapshot<List<Appointment>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else {
              final appointments = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (appointments.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) => _buildVeterinaryAppointmentCard(context, appointments[index]),
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VeterinaryHomePage()),
                      );
                    },
                    icon: const Icon(Icons.local_hospital, color: Colors.white), // Màu trắng cho icon
                    label: const Text('Đến Thú Y', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff7FDDE5),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _buildVeterinaryAppointmentCard(BuildContext context, Appointment appointment) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          '${appointment.petName} - ${DateFormat('dd/MM/yyyy').format(appointment.date)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text('Giờ: ${TimeOfDay.fromDateTime(appointment.date).format(context)}'),
        childrenPadding: const EdgeInsets.all(16),
        children: <Widget>[
          _buildInfoRow('Thú y', appointment.veterinaryName),
          _buildInfoRow('Giống', appointment.breed),
          _buildInfoRow('Ngày khám', DateFormat('dd/MM/yyyy').format(appointment.date)),
          _buildInfoRow('Giờ khám', TimeOfDay.fromDateTime(appointment.date).format(context)),
          _buildInfoRow('Lý do khám', appointment.reason),
          if (appointment.note.isNotEmpty) _buildInfoRow('Ghi chú', appointment.note),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, 'appointment', appointment.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String type, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn xóa ${type == 'bookinghotel' ? 'đặt chỗ' : 'lịch khám'} này không?'),
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
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () {
                if (type == 'bookinghotel') {
                  Provider.of<BookingViewModel>(context, listen: false).deleteBooking(id);
                } else {
                  Provider.of<AppointmentViewModel>(context, listen: false).deleteAppointment(id);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}