import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/cat_calendar_model.dart';
import '../../viewmodels/calendar/cat_calendar_view_model.dart';
import '../../viewmodels/information/cat_list_view_model.dart';
import '../../models/cat_information_model.dart';
import '../home/home_page.dart'; // Import HomePage

class CatCalendarScreen extends StatefulWidget {
  @override
  _CatCalendarScreenState createState() => _CatCalendarScreenState();
}

class _CatCalendarScreenState extends State<CatCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final _formKey = GlobalKey<FormState>();
  CatEvent? _selectedEvent;
  String? _selectedCatId;
  List<Cat> _cats = [];
  bool _isLoading = true;
  late CatCalendarViewModel _catCalendarViewModel;

  final _vaccinationDateController = TextEditingController();
  final _matingDateController = TextEditingController();
  final _heatStartDateController = TextEditingController();
  final _heatEndDateController = TextEditingController();
  final _deliveryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final catListViewModel =
      Provider.of<CatListViewModel>(context, listen: false);
      await catListViewModel.loadCats();
      _cats = catListViewModel.cats;
      if (_cats.isNotEmpty) {
        _selectedCatId = _cats.first.id;
      }
      _catCalendarViewModel = CatCalendarViewModel(_selectedCatId ?? "");
    } catch (e) {
      print('Lỗi khi tải dữ liệu: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _vaccinationDateController.dispose();
    _matingDateController.dispose();
    _heatStartDateController.dispose();
    _heatEndDateController.dispose();
    _deliveryDateController.dispose();
    _catCalendarViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch theo dõi Mèo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(), // Navigate to HomePage
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_alarm, color: Colors.white),
            onPressed: () {
              _showAddEventDialog(
                  context,
                  Provider.of<CatCalendarViewModel>(context,
                      listen: false));
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ChangeNotifierProvider.value(
        value: _catCalendarViewModel,
        child: Consumer<CatCalendarViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCatDropdown(),
                  _buildCalendar(viewModel.events),
                  _buildEventDetails(),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(
              context,
              Provider.of<CatCalendarViewModel>(context,
                  listen: false));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildCatDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: _selectedCatId,
        hint: Text('Chọn mèo'),
        items: _cats.map((Cat cat) {
          return DropdownMenuItem<String>(
            value: cat.id,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(cat.name![0]),
                ),
                SizedBox(width: 8.0),
                Text(cat.name ?? 'Không tên'),
              ],
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedCatId = newValue;
          });
          if (newValue != null) {
            _catCalendarViewModel.init(newValue);
          }
        },
        isExpanded: true,
        underline: Container(),
      ),
    );
  }

  Widget _buildCalendar(List<CatEvent> events) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          locale: 'vi_VN',
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _loadSelectedEvent(events);
              _updateControllers();
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          headerStyle: HeaderStyle(
            titleTextStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            formatButtonTextStyle: TextStyle(color: Colors.white),
            formatButtonDecoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          eventLoader: (day) {
            return _getEventsForDay(day, events);
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return _buildEventsMarkers(date, events);
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  List<CatEvent> _getEventsForDay(DateTime day, List<CatEvent> events) {
    return events.where((event) => _isSameDay(event.date, day)).toList();
  }

  Future<void> _loadSelectedEvent(List<CatEvent> events) async {
    _selectedEvent = events.firstWhere(
          (event) => _isSameDay(event.date, _selectedDay),
      orElse: () => CatEvent(catId: _selectedCatId, date: _selectedDay),
    );
  }

  Widget _buildEventsMarkers(DateTime date, List events) {
    return Positioned(
      right: 1,
      bottom: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        width: 16.0,
        height: 16.0,
        child: Center(
          child: Text(
            '${events.length}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetails() {
    final catListViewModel =
    Provider.of<CatListViewModel>(context, listen: false);
    Cat? selectedCat;
    if (_selectedCatId != null) {
      selectedCat = catListViewModel.cats.firstWhere(
            (cat) => cat.id == _selectedCatId,
        orElse: () => Cat(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedDay != null
                  ? 'Chi tiết sự kiện ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}'
                  : 'Chi tiết sự kiện',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            _buildVaccinationDateInput(),
            _buildMatingDateInput(),
            _buildHeatCycleInput(),
            if (selectedCat != null && selectedCat.gender == 'Cái')
              _buildDeliveryDateInput(),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveEventChanges(context);
                    }
                  },
                  child: Text('Lưu thay đổi', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteEvent(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Xóa', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteEvent(BuildContext context) async {
    if (_selectedEvent != null && _selectedEvent!.id != null) {
      final viewModel = Provider.of<CatCalendarViewModel>(context, listen: false);
      await viewModel.deleteCatEvent(_selectedEvent!.id!);
      setState(() {
        _selectedEvent = null;
        _updateControllers();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa sự kiện')),
      );
    }
  }

  Widget _buildVaccinationDateInput() {
    return _buildDateInput('Ngày chích ngừa', _vaccinationDateController,
        Icons.local_hospital);
  }

  Widget _buildMatingDateInput() {
    return _buildDateInput('Ngày phối giống', _matingDateController, Icons.favorite);
  }

  Widget _buildHeatCycleInput() {
    return _buildDateInput('Ngày động dục', _heatStartDateController,
        Icons.local_fire_department);
  }

  Widget _buildDeliveryDateInput() {
    return _buildDateInput('Ngày sinh đẻ', _deliveryDateController, Icons.child_care);
  }

  Widget _buildDateInput(String label, TextEditingController controller,
      IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _selectDate(controller),
        child: IgnorePointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: 'Chọn ngày',
              suffixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              return null;
            },
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _updateControllers() {
    _vaccinationDateController.text =
        _formatDate(_selectedEvent?.vaccinationDate);
    _matingDateController.text = _formatDate(_selectedEvent?.matingDate);
    _heatStartDateController.text =
        _formatDate(_selectedEvent?.heatStartDate);
    _heatEndDateController.text = _formatDate(_selectedEvent?.heatEndDate);
    _deliveryDateController.text =
        _formatDate(_selectedEvent?.deliveryDate);
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('dd/MM/yyyy').format(date) : '';
  }

  Future<void> _saveEventChanges(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final viewModel =
      Provider.of<CatCalendarViewModel>(context, listen: false);

      if (_selectedEvent != null) {
        _selectedEvent!.vaccinationDate =
            _parseDate(_vaccinationDateController.text);
        _selectedEvent!.matingDate = _parseDate(_matingDateController.text);
        _selectedEvent!.heatStartDate =
            _parseDate(_heatStartDateController.text);
        _selectedEvent!.heatEndDate =
            _parseDate(_heatEndDateController.text);
        _selectedEvent!.deliveryDate =
            _parseDate(_deliveryDateController.text);

        print('vaccinationDate: ${_selectedEvent!.vaccinationDate}');
        print('matingDate: ${_selectedEvent!.matingDate}');

        if (_selectedEvent!.catId != null) {
          await viewModel.updateCatEvent(
              _selectedEvent!.catId!, _selectedEvent!.toMap());
        } else {
          await viewModel.addCatEvent(_selectedEvent!.toMap() as CatEvent);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã lưu thay đổi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không có sự kiện nào để lưu')),
        );
      }
    }
  }

  DateTime? _parseDate(String? dateString) {
    print('dateString: $dateString');
    try {
      return dateString != null && dateString.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(dateString)
          : null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _showAddEventDialog(
      BuildContext context, CatCalendarViewModel viewModel) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedTime = DateTime.now();
    Color selectedColor = Colors.orange;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm sự kiện'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Tiêu đề'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Mô tả'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedTime),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = DateTime(
                          _selectedDay!.year,
                          _selectedDay!.month,
                          _selectedDay!.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  },
                  child: Text('Chọn thời gian'),
                ),
                Text(
                  selectedTime != null
                      ? 'Thời gian đã chọn: ${DateFormat('HH:mm').format(selectedTime)}'
                      : 'Chưa chọn thời gian',
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColorOption(Colors.red, selectedColor, (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    }),
                    _buildColorOption(Colors.blue, selectedColor, (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    }),
                    _buildColorOption(Colors.green, selectedColor, (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    }),
                    _buildColorOption(Colors.orange, selectedColor, (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    }),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final newEvent = CatEvent(
                    catId: _selectedCatId,
                    title: titleController.text,
                    date: selectedTime,
                    color: _colorToString(selectedColor),
                    description: descriptionController.text,
                  );
                  viewModel.addCatEvent(newEvent);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorOption(Color color, Color selectedColor,
      ValueChanged<Color> onSelect) {
    return GestureDetector(
      onTap: () {
        onSelect(color);
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 16.0,
        child: color == selectedColor
            ? Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }

  String _colorToString(Color color) {
    return '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  // ignore: unused_element
  Color _stringToColor(String colorString) {
    return Color(int.parse(colorString.substring(2), radix: 16));
  }

  bool _isSameDay(DateTime? d1, DateTime? d2) {
    if (d1 == null || d2 == null) return false;
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}