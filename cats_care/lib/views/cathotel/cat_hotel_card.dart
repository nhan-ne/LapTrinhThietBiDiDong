import 'package:flutter/material.dart';

class CatHotelCard extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final String services;
  final String image;
  final VoidCallback onBook;

  CatHotelCard({
    required this.name,
    required this.address,
    required this.phone,
    required this.services,
    required this.image,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 55,
                width: 55,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              address,
              style: TextStyle(fontSize: 10),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            if (phone.isNotEmpty)
              Text(
                phone,
                style: TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (services.isNotEmpty)
              Text(
                services,
                style: TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: onBook,
                child: Text('ĐẶT CHỖ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}