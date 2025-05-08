import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/cat_calendar_model.dart';
import '../../viewmodels/calendar/cat_calendar_view_model.dart';
import '../../viewmodels/information/cat_list_view_model.dart';
import '../../models/cat_information_model.dart';
import '../home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CatCalendarScreen extends StatefulWidget {
  @override
  _CatCalendarScreenState createState() => _CatCalendarScreenState();
}

class _CatCalendarScreenState extends State<CatCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  String? _selectedCatId;
  Cat? _selectedCat;
  // ignore: unused_field
  int _selectedCatIndex = 0;
  List<Cat> _cats = [];
  bool _isLoading = true;
  // ignore: unused_field
  DateTime? _selectedDay;

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
        _selectedCat = _cats.first;
        _selectedCatId = _cats.first.id;
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch theo dõi mèo',
          style: TextStyle(fontSize: 24,color: Colors.white),
        ),
        backgroundColor: const Color(0xff7FDDE5),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddExternalEventDialog, // Gọi hàm này khi nhấn
          ),
        ],
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ChangeNotifierProvider(
        create: (context) => CatCalendarViewModel(_selectedCatId),
        child: Consumer<CatCalendarViewModel>(
          builder: (context, viewModel, _) {
            if (_selectedCatId != viewModel.catId) {
              viewModel.loadEvents(_selectedCatId!);
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCatSelectionDropdown(),
                  _buildCalendar(viewModel.events),
                  _buildEventDetails(viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCatSelectionDropdown() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedCat?.name ?? 'Chọn một con mèo',
            style: TextStyle(fontSize: 20),
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.arrow_drop_down),
            onSelected: (int index) {
              setState(() {
                _selectedCat = _cats[index];
                _selectedCatId = _cats[index].id;
                _selectedCatIndex = index;
              });
            },
            itemBuilder: (BuildContext context) {
              return List<PopupMenuEntry<int>>.generate(
                _cats.length,
                    (int index) => PopupMenuItem<int>(
                  value: index,
                  child: Text(_cats[index].name ?? 'Không có tên'),
                ),
              );
            },
          ),
        ],
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
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) {
            return _isSameDay(_focusedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _focusedDay = selectedDay;
            });
            _showEventsForSelectedDay(selectedDay, events); // Hiển thị sự kiện khi chọn ngày
          },
          headerStyle: HeaderStyle(
            titleTextStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            formatButtonVisible: false,
          ),
          calendarStyle: CalendarStyle(
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

  void _showEventsForSelectedDay(DateTime day, List<CatEvent> events) {
    final selectedEvents = _getEventsForDay(day, events);
    if (selectedEvents.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sự kiện trong ngày"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: selectedEvents.map((event) => _buildEventDetail(event)).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Đóng"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không có sự kiện nào trong ngày này.')),
      );
    }
  }

  Widget _buildEventDetail(CatEvent event) {
    return ListTile(
      title: Text(event.title ?? 'Không có tiêu đề'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ngày: ${DateFormat('dd/MM/yyyy').format(event.date ?? DateTime.now())}'),
          if (event.note != null) Text('Ghi chú: ${event.note}'),
        ],
      ),
    );
  }

  List<CatEvent> _getEventsForDay(DateTime day, List<CatEvent> events) {
    return events.where((event) => _isSameDay(event.date, day)).toList();
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

  Widget _buildEventDetails(CatCalendarViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi tiết sự kiện',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          _buildVaccinationSection(viewModel),
          _buildMatingSection(viewModel),
          _buildHeatSection(viewModel),
          _buildDeliverySection(viewModel),
        ],
      ),
    );
  }

  Widget _buildVaccinationSection(CatCalendarViewModel viewModel) {
    return _buildEventSection(
      'Lịch Chích Ngừa',
      viewModel.events.where((event) => event.vaccinationDate != null).toList(),
          (event) => event.vaccinationDate!,
          () => _showAddVaccinationDialog(context, viewModel),
      viewModel,
    );
  }

  Widget _buildMatingSection(CatCalendarViewModel viewModel) {
    return _buildEventSection(
      'Lịch Phối Giống',
      viewModel.events.where((event) => event.matingDate != null).toList(),
          (event) => event.matingDate!,
          () => _showAddMatingDialog(context, viewModel),
      viewModel,
    );
  }

  Widget _buildHeatSection(CatCalendarViewModel viewModel) {
    return _buildEventSection(
      'Lịch Động Dục',
      viewModel.events.where((event) => event.heatStartDate != null).toList(),
          (event) => event.heatStartDate!,
          () => _showAddHeatDialog(context, viewModel),
      viewModel,
    );
  }

  Widget _buildDeliverySection(CatCalendarViewModel viewModel) {
    return _buildEventSection(
      'Lịch Sinh Đẻ',
      viewModel.events.where((event) => event.deliveryDate != null).toList(),
          (event) => event.deliveryDate!,
          () => _showAddDeliveryDialog(context, viewModel),
      viewModel,
    );
  }

  Widget _buildEventSection(
      String title,
      List<CatEvent> events,
      DateTime? Function(CatEvent) getDate,
      VoidCallback onAddPressed,
      CatCalendarViewModel viewModel,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: onAddPressed,
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Thêm $title',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(''),
          )
        else
          ...events.map((event) => _buildEventItem(event, getDate(event)!, viewModel)),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildEventItem(CatEvent event, DateTime date, CatCalendarViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.event),
          SizedBox(width: 8.0),
          Text(DateFormat('dd/MM/yyyy').format(date)),
          if (event.title != null) ...[
            SizedBox(width: 8.0),
            Text(event.title!),
          ],
          Spacer(),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteEventDialog(context, viewModel, event);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteEventDialog(
      BuildContext context, CatCalendarViewModel viewModel, CatEvent event) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xóa Sự Kiện'),
          content: Text('Bạn có chắc chắn muốn xóa sự kiện này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                await viewModel.deleteEvent(_selectedCatId!, event.id!);
                Navigator.of(context).pop();
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddVaccinationDialog(
      BuildContext context, CatCalendarViewModel viewModel) async {
    if (_selectedCatId == null) {
      _showMissingCatDialog(context);
      return;
    }
    final dateController = TextEditingController();
    await _showAddEventDialog(context, 'Thêm Lịch Chích Ngừa', dateController,
            (date) async {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
          await viewModel.addVaccinationDate(
              _selectedCatId!, date, null, uid); // title
          Navigator.of(context).pop();
          viewModel.loadEvents(_selectedCatId!);
        }
      else {
        // Xử lý trường hợp không có uid
      }
    });
  }

  Future<void> _showAddMatingDialog(
      BuildContext context, CatCalendarViewModel viewModel) async {
    if (_selectedCatId == null) {
      _showMissingCatDialog(context);
      return;
    }
    final dateController = TextEditingController();
    await _showAddEventDialog(context, 'Thêm Lịch Phối Giống', dateController,
            (date) async {
        String? uid = FirebaseAuth.instance.currentUser?.uid; // Lấy uid
        if (uid != null) {
          await viewModel.addMatingDate(
              _selectedCatId!, date, null, uid); // title
          Navigator.of(context).pop();
          viewModel.loadEvents(_selectedCatId!);
          }
        else {
          // Xử lý trường hợp không có uid
        }
        });
  }

  Future<void> _showAddHeatDialog(
      BuildContext context, CatCalendarViewModel viewModel) async {
    if (_selectedCatId == null) {
      _showMissingCatDialog(context);
      return;
    }
    final dateController = TextEditingController();
    await _showAddEventDialog(context, 'Thêm Lịch Động Dục', dateController,
            (date) async {
      String? uid = FirebaseAuth.instance.currentUser?.uid; // Lấy uid
      if (uid != null) {
        await viewModel.addHeatDate(
            _selectedCatId!, date, null, null, uid); // start, end
        Navigator.of(context).pop();
        viewModel.loadEvents(_selectedCatId!);
      }
        });
  }

  Future<void> _showAddDeliveryDialog(
      BuildContext context, CatCalendarViewModel viewModel) async {
    if (_selectedCatId == null) {
      _showMissingCatDialog(context);
      return;
    }
    final dateController = TextEditingController();
    await _showAddEventDialog(context, 'Thêm Lịch Sinh Đẻ', dateController,
            (date) async {
      String? uid = FirebaseAuth.instance.currentUser?.uid; // Lấy uid
      if (uid != null) {
        await viewModel.addDeliveryDate(
            _selectedCatId!, date, null, uid); // title
        Navigator.of(context).pop();
        viewModel.loadEvents(_selectedCatId!);
      }
        });
  }

  void _showMissingCatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chưa chọn mèo'),
        content: Text('Vui lòng chọn mèo trước khi lưu sự kiện.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddEventDialog(BuildContext context, String title,
      TextEditingController dateController,
      Function(DateTime) onSave) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: dateController,
            decoration: InputDecoration(labelText: 'Chọn ngày'),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                dateController.text = DateFormat('dd/MM/yyyy').format(picked);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final date = DateFormat('dd/MM/yyyy')
                    .parse(dateController.text);
                onSave(date);
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddExternalEventDialog({CatEvent? event}) async {
    final dateController = TextEditingController();
    final titleController = TextEditingController();
    final noteController = TextEditingController();

    if (event != null) {
      dateController.text = DateFormat('dd/MM/yyyy').format(event.date!);
      titleController.text = event.title ?? '';
      noteController.text = event.note ?? '';
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event == null ? 'Thêm Sự Kiện' : 'Sửa Sự Kiện'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Chọn ngày'),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      dateController.text =
                          DateFormat('dd/MM/yyyy').format(picked);
                    }
                  },
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Tên sự kiện'),
                ),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(labelText: 'Ghi chú'),
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
                final date = DateFormat('dd/MM/yyyy').parse(dateController.text);
                final title = titleController.text;
                final note = noteController.text;
                final user = FirebaseAuth.instance.currentUser;

                final viewModel = Provider.of<CatCalendarViewModel>(context, listen: false);

                if (event == null) {
                  // Thêm sự kiện mới
                  viewModel.addExternalEvent(_selectedCatId!, date, title, note, user!.uid);
                } else {
                  // Cập nhật sự kiện
                  viewModel.updateCatEvent(event.id!, {
                    'date': date,
                    'title': title,
                    'note': note,
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Lưu'),
            ),
            if (event != null) // Chỉ hiển thị nút xóa khi đang sửa sự kiện
              ElevatedButton(
                onPressed: () {
                  final viewModel = Provider.of<CatCalendarViewModel>(context, listen: false);
                  viewModel.deleteExternalEvent(_selectedCatId!, event.id!);
                  Navigator.of(context).pop();
                },
                child: Text('Xóa'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime? d1, DateTime? d2) {
    if (d1 == null || d2 == null) return false;
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}