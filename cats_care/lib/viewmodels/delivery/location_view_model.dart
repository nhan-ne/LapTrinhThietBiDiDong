import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationViewModel extends ChangeNotifier {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra dịch vụ vị trí
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí không được bật.');
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Quyền truy cập vị trí bị từ chối.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Quyền truy cập vị trí bị từ chối vĩnh viễn.');
    }

    // Lấy vị trí hiện tại
    return await Geolocator.getCurrentPosition();
  }

  // Chuyển đổi tọa độ thành địa chỉ
  Future<String> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception('Không tìm thấy địa chỉ.');
      }

      Placemark place = placemarks[0];
      // return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      return [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((element) => element != null && element.isNotEmpty).join(', ');
    } catch (e) {
      throw Exception('Không thể chuyển đổi tọa độ thành địa chỉ: $e');
    }
  }
}