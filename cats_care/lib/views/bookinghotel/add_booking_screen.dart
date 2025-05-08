import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/bookinghotel/booking_view_model.dart';
import '../cathotel/cat_hotel_home_screen.dart';

class AddBookingScreen extends StatefulWidget {
  final String? hotelName;

  const AddBookingScreen({Key? key, this.hotelName}) : super(key: key);

  @override
  _AddBookingScreenState createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _catNameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedRoomType;
  String? _selectedCatWeight;
  final ScrollController _scrollController = ScrollController();

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          // Đảm bảo ngày trả phòng không trước ngày nhận phòng
          if (_checkOutDate.isBefore(_checkInDate)) {
            _checkOutDate = _checkInDate.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
          // Đảm bảo ngày trả phòng không trước ngày nhận phòng
          if (_checkOutDate.isBefore(_checkInDate)) {
            _checkInDate = _checkInDate;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingViewModel = Provider.of<BookingViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đặt chỗ',
          style: TextStyle(fontSize: 24,color: Colors.white),
        ),
        backgroundColor: const Color(0xff7FDDE5),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CatHotelHomePage(),
                ),
              );
            },
          )
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Các trường nhập liệu
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(labelText: 'Tên khách hàng'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên khách hàng';
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
                controller: _catNameController,
                decoration: const InputDecoration(labelText: 'Tên mèo'),
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
                decoration: const InputDecoration(labelText: 'Giống mèo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giống mèo';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Chọn ngày nhận/trả phòng
              const Text(
                'CHỌN NGÀY NHẬN/TRẢ PHÒNG',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildCalendar(context),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRoomType,
                items: const [
                  DropdownMenuItem(value: "Cơ bản (150-200/ngày)", child: Text("Cơ bản (150-200 /ngày)")),
                  DropdownMenuItem(value: "VIP (250-350/ngày)", child: Text("VIP (250-350 /ngày)")),
                ].map((item) => DropdownMenuItem<String>(
                  value: item.value,
                  child: Text(item.value!),
                )).toList(),
                decoration: const InputDecoration(labelText: 'Loại phòng'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn loại phòng';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedRoomType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCatWeight,
                items: const [
                  DropdownMenuItem(value: "Dưới 3kg", child: Text("Mèo dưới 3kg")),
                  DropdownMenuItem(value: "Trên 3kg", child: Text("Mèo trên 3kg")),
                ].map((item) => DropdownMenuItem<String>(
                  value: item.value,
                  child: Text(item.value!),
                )).toList(),
                decoration: const InputDecoration(labelText: 'Cân nặng của mèo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn cân nặng của mèo';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedCatWeight = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Ghi chú đặc biệt'),
              ),

              const SizedBox(height: 24),

              // Nút đặt phòng
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      bookingViewModel.saveBooking(
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        customerName: _customerNameController.text,
                        phone: _phoneController.text,
                        catName: _catNameController.text,
                        breed: _breedController.text,
                        checkInDate: _checkInDate,
                        checkOutDate: _checkOutDate,
                        roomType: _selectedRoomType!,
                        notes: _notesController.text,
                        hotelName: widget.hotelName ?? "",
                        catWeight: _selectedCatWeight!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đặt phòng thành công!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7FDDE5),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    'ĐẶT PHÒNG',
                    style: TextStyle(color: Colors.white),
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
                      final newDate = DateTime(_checkInDate.year, _checkInDate.month - 1, _checkInDate.day);
                      _checkInDate = newDate;
                      _checkOutDate = DateTime(_checkOutDate.year, _checkOutDate.month - 1, _checkOutDate.day);
                      if (_checkOutDate.isBefore(_checkInDate)) {
                        _checkOutDate = _checkOutDate.add(const Duration(days: 1));
                      }
                    });
                  },
                ),
                Text(
                  DateFormat('Tháng M, yyyy').format(_checkInDate),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      final newDate = DateTime(_checkInDate.year, _checkInDate.month + 1, _checkInDate.day);
                      _checkInDate = newDate;
                      _checkOutDate = DateTime(_checkOutDate.year, _checkOutDate.month + 1, _checkOutDate.day);
                      if (_checkOutDate.isBefore(_checkInDate)) {
                        _checkOutDate = _checkOutDate.add(const Duration(days: 1));
                      }
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
            itemCount: _getDaysInMonth(_checkInDate.year, _checkInDate.month),
            itemBuilder: (context, index) {
              final day = index + 1;
              final currentDate = DateTime(_checkInDate.year, _checkInDate.month, day);
              final isCheckIn = currentDate.day == _checkInDate.day &&
                  currentDate.month == _checkInDate.month &&
                  currentDate.year == _checkInDate.year;
              final isCheckOut = currentDate.day == _checkOutDate.day &&
                  currentDate.month == _checkOutDate.month &&
                  currentDate.year == _checkOutDate.year;
              final isInRange = currentDate.isAfter(_checkInDate.subtract(const Duration(days: 1))) &&
                  currentDate.isBefore(_checkOutDate.add(const Duration(days: 1)));

              Color? backgroundColor;
              Color textColor = Colors.black;

              if (isCheckIn) {
                backgroundColor = const Color(0xff7FDDE5);
                textColor = Colors.white;
              } else if (isCheckOut) {
                backgroundColor = const Color(0xff7FDDE5);
                textColor = Colors.white;
              } else if (isInRange) {
                backgroundColor = Colors.grey.shade200;
              }

              return GestureDetector(
                onTap: () {
                  _selectDate(context, _checkInDate == currentDate);
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                  child: Text('Ngày nhận: ${DateFormat('dd/MM').format(_checkInDate)}'),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                  child: Text('Ngày trả: ${DateFormat('dd/MM').format(_checkOutDate)}'),
                ),
              ],
            ),
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
}