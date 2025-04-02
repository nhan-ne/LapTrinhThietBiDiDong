import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'info_card.dart'; //
import 'mood_icon.dart'; //

class BabyTrackingScreen extends StatefulWidget {
  const BabyTrackingScreen({Key? key}) : super(key: key);

  @override
  State<BabyTrackingScreen> createState() => _BabyTrackingScreenState();
}

class _BabyTrackingScreenState extends State<BabyTrackingScreen> {
  DateTime _selectedDate = DateTime(2025, 3, 31);
  int _currentMonth = 3;
  int _currentYear = 2025;
  List<DateTime> _daysInMonth = [];
  DateTime? _kyTimBanDoiBatDau;
  DateTime? _kyTimBanDoiKetThuc;
  DateTime? _ngaySinhDeDate;
  String _tamTrang = '';
  String _canNang = '';
  String _chieuCao = '';
  String _chuViDau = '';
  bool _kyTimBanDoiDangDienRa = false;

  @override
  void initState() {
    super.initState();
    _generateDaysInMonth();
  }

  void _generateDaysInMonth() {
    _daysInMonth.clear();
    final firstDayOfMonth = DateTime(_currentYear, _currentMonth, 1);
    final lastDayOfMonth = DateTime(_currentYear, _currentMonth + 1, 0);

    // Thêm các ngày "trống" ở đầu tháng nếu cần
    final firstDayOfWeek = firstDayOfMonth.weekday;
    for (int i = 0; i < (firstDayOfWeek == DateTime.monday ? 0 : firstDayOfWeek - 1); i++) {
      final prevMonthDay = firstDayOfMonth.subtract(Duration(days: firstDayOfWeek - 1 - i));
      _daysInMonth.add(DateTime(0, 0, prevMonthDay.day));
    }

    // Thêm các ngày trong tháng
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      _daysInMonth.add(DateTime(_currentYear, _currentMonth, i));
    }

    // Thêm các ngày "trống" ở cuối tháng nếu cần
    final lastDayOfWeek = lastDayOfMonth.weekday;
    for (int i = 1; i <= (lastDayOfWeek == DateTime.sunday ? 0 : 7 - lastDayOfWeek); i++) {
      final nextMonthDay = lastDayOfMonth.add(Duration(days: i));
      _daysInMonth.add(DateTime(0, 0, nextMonthDay.day));
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth--;
      if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
      }
      _generateDaysInMonth();
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth++;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
      }
      _generateDaysInMonth();
    });
  }

  void _selectDate(DateTime day) {
    if (day.year != 0) {
      setState(() {
        _selectedDate = day;
      });
    }
  }

  void _setKyTimBanDoiDaToi() {
    setState(() {
      _kyTimBanDoiBatDau = _selectedDate;
      _kyTimBanDoiKetThuc = null; // Reset ngày kết thúc nếu bắt đầu lại
      _kyTimBanDoiDangDienRa = true;
    });
  }

  void _setKyTimBanDoiKetThuc() {
    setState(() {
      _kyTimBanDoiKetThuc = _selectedDate;
      _kyTimBanDoiDangDienRa = false;
    });
  }

  bool _isKyTimBanDoiOnDate(DateTime date) {
    return _kyTimBanDoiBatDau != null &&
        date.year == _kyTimBanDoiBatDau!.year &&
        date.month == _kyTimBanDoiBatDau!.month &&
        date.day == _kyTimBanDoiBatDau!.day;
  }

  bool _isNgayTrongKyTimBanDoi(DateTime date) {
    if (_kyTimBanDoiBatDau == null) {
      return false;
    }
    DateTime ketThuc = _kyTimBanDoiKetThuc ?? _kyTimBanDoiBatDau!.add(const Duration(days: 20)); // Dự kiến kết thúc
    return date.isAfter(_kyTimBanDoiBatDau!.subtract(const Duration(days: 1))) && date.isBefore(ketThuc.add(const Duration(days: 1)));
  }

  // Định nghĩa các phương thức bị thiếu
  void _setNgaySinhDeDaToi() {
    setState(() {
      _ngaySinhDeDate = _selectedDate;
    });
  }

  bool _isNgaySinhDeOnSelectedDate() {
    return _ngaySinhDeDate != null &&
        _selectedDate.year == _ngaySinhDeDate!.year &&
        _selectedDate.month == _ngaySinhDeDate!.month &&
        _selectedDate.day == _ngaySinhDeDate!.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.teal[200],
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[300],
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Bé 1', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[100],
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Bé 2', style: TextStyle(fontSize: 18, color: Colors.black87)),
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: _previousMonth,
                        ),
                        Text(
                          DateFormat('MMMM', 'vi_VN').format(DateTime(_currentYear, _currentMonth)),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                      ),
                      itemCount: _daysInMonth.length,
                      itemBuilder: (context, index) {
                        final day = _daysInMonth[index];
                        final isSameDay = day.year != 0 &&
                            day.day == _selectedDate.day &&
                            day.month == _selectedDate.month &&
                            day.year == _selectedDate.year;
                        final isCurrentMonth = day.year != 0 && day.month == _currentMonth;
                        final isKyTimBanDoi = _isKyTimBanDoiOnDate(day);
                        final isNgayTrongKyTimBanDoi = _isNgayTrongKyTimBanDoi(day);

                        return Center(
                          child: GestureDetector(
                            onTap: () => _selectDate(day),
                            child: Stack(
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: isSameDay ? Colors.orange[300] : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      day.year == 0 ? '' : day.day.toString(),
                                      style: TextStyle(
                                        color: isCurrentMonth ? Colors.black87 : Colors.grey,
                                        fontWeight: isSameDay ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isKyTimBanDoi)
                                  Positioned(
                                    bottom: 2,
                                    left: 2,
                                    child: Icon(Icons.favorite, color: Colors.red[300], size: 12),
                                  ),
                                if (isNgayTrongKyTimBanDoi)
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: Icon(Icons.timeline, color: Colors.blue[300], size: 12),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InfoCard( // Use InfoCard widget
                title: 'Ngày tiêm phòng',
                child: Row(
                  children: [
                    const Icon(Icons.medical_services_outlined, color: Colors.blueGrey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2026),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InfoCard( // Use InfoCard widget
                title: 'Kỳ tìm bạn đời',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: _kyTimBanDoiDangDienRa ? null : _setKyTimBanDoiDaToi, // Disable nếu đang diễn ra
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isKyTimBanDoiOnDate(_selectedDate)
                                ? Colors.green[700]
                                : Colors.green[300],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text('Đã tới', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: _kyTimBanDoiDangDienRa ? _setKyTimBanDoiKetThuc : null, // Disable nếu chưa bắt đầu
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kyTimBanDoiDangDienRa ? Colors.orange[700] : Colors.orange[300],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text(_kyTimBanDoiKetThuc == null ? 'Kết thúc' : 'Đã kết thúc', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    if (_kyTimBanDoiBatDau != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Bắt đầu: ${DateFormat('dd/MM/yyyy').format(_kyTimBanDoiBatDau!)}'
                              '${_kyTimBanDoiKetThuc != null ? ' - Kết thúc: ${DateFormat('dd/MM/yyyy').format(_kyTimBanDoiKetThuc!)}' : ''}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              InfoCard( // Use InfoCard widget
                title: 'Ngày sinh đẻ',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _setNgaySinhDeDaToi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isNgaySinhDeOnSelectedDate()
                            ? Colors.green[700]
                            : Colors.green[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('Đã tới', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _ngaySinhDeDate = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _ngaySinhDeDate == null || !_isNgaySinhDeOnSelectedDate()
                            ? Colors.orange[300]
                            : Colors.orange[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('Chưa tới', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              InfoCard( // Use InfoCard widget
                title: 'Tâm trạng',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MoodIcon( // Use MoodIcon widget
                      icon: '\u{1F60A}',
                      selectedTamTrang: _tamTrang,
                      onTap: (icon) {
                        setState(() {
                          _tamTrang = icon;
                        });
                        print('Đã chọn tâm trạng: $_tamTrang');
                      },
                    ),
                    MoodIcon( // Use MoodIcon widget
                      icon: '\u{1F604}',
                      selectedTamTrang: _tamTrang,
                      onTap: (icon) {
                        setState(() {
                          _tamTrang = icon;
                        });
                        print('Đã chọn tâm trạng: $_tamTrang');
                      },
                    ),
                    MoodIcon( // Use MoodIcon widget
                      icon: '\u{1F610}',
                      selectedTamTrang: _tamTrang,
                      onTap: (icon) {
                        setState(() {
                          _tamTrang = icon;
                        });
                        print('Đã chọn tâm trạng: $_tamTrang');
                      },
                    ),
                    MoodIcon( // Use MoodIcon widget
                      icon: '\u{1F641}',
                      selectedTamTrang: _tamTrang,
                      onTap: (icon) {
                        setState(() {
                          _tamTrang = icon;
                        });
                        print('Đã chọn tâm trạng: $_tamTrang');
                      },
                    ),
                    MoodIcon( // Use MoodIcon widget
                      icon: '\u{1F62D}',
                      selectedTamTrang: _tamTrang,
                      onTap: (icon) {
                        setState(() {
                          _tamTrang = icon;
                        });
                        print('Đã chọn tâm trạng: $_tamTrang');
                      },
                    ),
                    MoodIcon( // Use MoodIcon widget
                      icon: '\u{1F620}',
                      selectedTamTrang: _tamTrang,
                      onTap: (icon) {
                        setState(() {
                          _tamTrang = icon;
                        });
                        print('Đã chọn tâm trạng: $_tamTrang');
                      },
                    ),
                  ],
                ),
              ),
              InfoCard( // Use InfoCard widget
                title: 'Cân nặng (kg)',
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập cân nặng',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _canNang = value;
                    });
                  },
                ),
              ),
              InfoCard( // Use InfoCard widget
                title: 'Chiều cao (cm)',
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập chiều cao',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _chieuCao = value;
                    });
                  },
                ),
              ),
              InfoCard( // Use InfoCard widget
                title: 'Ghi chú',
                child: const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập ghi chú',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Lịch'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}