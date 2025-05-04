import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/appointment/appointment_view_model.dart';
import 'package:intl/intl.dart';

class AddAppointmentScreen extends StatefulWidget {
  final String? veterinaryName;

  const AddAppointmentScreen({Key? key, this.veterinaryName}) : super(key: key);

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _vaccinationHistoryController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _currentSymptomsController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 0, minute: 0); // Initialize with a default time
  final ScrollController _scrollController = ScrollController(); // Added scroll controller


  // ignore: unused_element
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay time) async {
    setState(() {
      _selectedTime = time;
    });
  }




  @override
  Widget build(BuildContext context) {
    final appointmentViewModel = Provider.of<AppointmentViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ĐẶT LỊCH KHÁM',
          style: TextStyle(fontWeight: FontWeight.bold), // Bold title
        ),
        backgroundColor: const Color(0xff7FDDE5), // White AppBar
        foregroundColor: Colors.black, // Black title and icons
        elevation: 0, // No shadow
        centerTitle: true, // Center the title
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Form Fields
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên của bạn'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên của bạn';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _petNameController,
                decoration: const InputDecoration(labelText: 'Tên mèo của bạn'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên mèo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Giống'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giống';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vaccinationHistoryController,
                decoration: const InputDecoration(labelText: 'Lịch sử tiêm phòng và tẩy giun'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medicalHistoryController,
                decoration: const InputDecoration(labelText: 'Tiền sử bệnh (Nếu có)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentSymptomsController,
                decoration: const InputDecoration(labelText: 'Các vấn đề sức khỏe hiện tại hoặc triệu chứng'),
              ),

              const SizedBox(height: 24),

              // Chọn ngày khám
              const Text(
                'CHỌN NGÀY KHÁM',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildCalendar(context),

              const SizedBox(height: 24),

              // Chọn giờ khám
              const Text(
                'CHỌN GIỜ KHÁM',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildTimeSlots(context),

              const SizedBox(height: 24),

              // Nút đặt lịch
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      appointmentViewModel.saveAppointment(
                        petName: _petNameController.text,
                        breed: _breedController.text,
                        date: _selectedDate,
                        time: _selectedTime,
                        reason: _reasonController.text,
                        note: _noteController.text,
                        name: _nameController.text, // Đảm bảo tên tham số khớp
                        phone: _phoneController.text,
                        vaccinationHistory: _vaccinationHistoryController.text,
                        medicalHistory: _medicalHistoryController.text,
                        currentSymptoms: _currentSymptomsController.text,
                        veterinaryName: widget.veterinaryName ?? "",
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lịch khám đã được đặt thành công!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7FDDE5), // Blue background
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    'ĐẶT LỊCH',
                    style: TextStyle(color: Colors.white), // White text
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
                    });
                  },
                ),
                Text(
                  DateFormat('Tháng M, yyyy').format(_selectedDate),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
                    });
                  },
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: _getDaysInMonth(_selectedDate.year, _selectedDate.month),
            itemBuilder: (context, index) {
              final day = index + 1;
              final currentDate = DateTime(_selectedDate.year, _selectedDate.month, day);
              final isSelected = currentDate.day == _selectedDate.day &&
                  currentDate.month == _selectedDate.month &&
                  currentDate.year == _selectedDate.year;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = currentDate;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xff7FDDE5) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int _getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[0, 31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return daysInMonth[month];
  }

  Widget _buildTimeSlots(BuildContext context) {
    final timeSlots = [
      '07:00 AM', '08:00 AM', '09:00 AM', '10:00 AM',
      '11:00 AM', '12:00 AM', '13:00 PM', '14:00 PM',
      '15:00 PM', '16:00 PM', '17:00 PM', '18:00 PM',
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: timeSlots.map((time) {
        final parsedTime = DateFormat('hh:mm a').parse(time);
        final timeOfDay = TimeOfDay.fromDateTime(parsedTime);
        final isSelected = _selectedTime == timeOfDay;

        return ChoiceChip(
          label: Text(time, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
          selected: isSelected,
          selectedColor: const Color(0xff7FDDE5),
          backgroundColor: Colors.grey.shade300,
          onSelected: (bool selected) {
            if (selected) {
              _selectTime(context, timeOfDay);
            }
          },
        );
      }).toList(),
    );
  }
}