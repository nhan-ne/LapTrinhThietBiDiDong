// veterinary_card.dart
import 'package:flutter/material.dart';

class VeterinaryCard extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final String hours;
  final String image;

  VeterinaryCard({
    required this.name,
    required this.address,
    required this.phone,
    required this.hours,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: 55, // Đặt chiều cao mong muốn cho ảnh
                      width: 55,  // Đặt chiều rộng mong muốn cho ảnh
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain, // Hoặc thử BoxFit.cover nếu muốn lấp đầy
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    address,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 5),
                  if (phone.isNotEmpty)
                    Text(
                      phone,
                      style: TextStyle(fontSize: 12),
                    ),
                  if (hours.isNotEmpty)
                    Text(
                      hours,
                      style: TextStyle(fontSize: 12),
                    ),
                  // You might need to add a Spacer here if the content above
                  // doesn't take up enough vertical space and the parent
                  // (e.g., GridView) has flexible height. However, in this
                  // specific card, the overflow is less likely.
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}