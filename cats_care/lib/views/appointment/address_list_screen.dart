import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Appointment.dart';
import '../../viewmodels/appointment/appointment_view_model.dart';
import 'package:intl/intl.dart';

import 'add_address_screen.dart';

class AppointmentListScreen extends StatelessWidget {
  const AppointmentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách lịch khám'),
      ),
      body: Consumer<AppointmentViewModel>(
        builder: (context, appointmentViewModel, child) {
          return FutureBuilder(
            future: appointmentViewModel.getAppointments(),
            builder: (context, AsyncSnapshot<List<Appointment>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Không có lịch khám nào.'));
              } else {
                final appointments = snapshot.data!;
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Tên thú cưng: ${appointment.petName}'),
                            Text('Giống: ${appointment.breed}'),
                            Text('Ngày khám: ${DateFormat('dd/MM/yyyy').format(appointment.date)}'),
                            Text('Giờ khám: ${TimeOfDay.fromDateTime(appointment.date).format(context)}'),
                            Text('Lý do khám: ${appointment.reason}'),
                            if (appointment.note.isNotEmpty) Text('Ghi chú: ${appointment.note}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    appointmentViewModel.deleteAppointment(appointment.id);
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
            MaterialPageRoute(builder: (context) => const AddAppointmentScreen()),
          );
        },
        tooltip: 'Thêm Lịch Khám',
        child: const Icon(Icons.add),
      ),
    );
  }
}