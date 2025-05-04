import 'package:flutter/material.dart';
// ignore: unused_import
import '/models/cat_breeds_model.dart';

class CatBreedDetailScreen extends StatelessWidget {
  final dynamic catBreed;

  CatBreedDetailScreen({required this.catBreed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(catBreed['name']),
        backgroundColor: const Color(0xff7FDDE5),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                catBreed['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Thông tin nổi bật'),
                  if (catBreed['weight'] != null)
                    _buildText('1. Cân nặng: ${catBreed['weight']}'),
                  if (catBreed['height'] != null)
                    _buildText('2. Chiều cao: ${catBreed['height']}'),
                  if (catBreed['lifespan'] != null)
                    _buildText('3. Tuổi thọ: ${catBreed['lifespan']}'),
                  if (catBreed['fur'] != null)
                    _buildText('4. Lông: ${catBreed['fur']}'),
                  _buildSectionTitle('Ngoại hình'),
                  if (catBreed['appearance'] != null &&
                      catBreed['appearance']['face'] != null)
                    _buildText(catBreed['appearance']['face']),
                  if (catBreed['appearance'] != null &&
                      catBreed['appearance']['longFur'] != null)
                    _buildText(catBreed['appearance']['longFur']),
                  if (catBreed['appearance'] != null &&
                      catBreed['appearance']['body'] != null)
                    _buildText(catBreed['appearance']['body']),
                  _buildSectionTitle('Vệ sinh'),
                  if (catBreed['grooming'] != null &&
                      catBreed['grooming']['brushing'] != null)
                    _buildText(catBreed['grooming']['brushing']),
                  if (catBreed['grooming'] != null &&
                      catBreed['grooming']['other'] != null)
                    _buildText(catBreed['grooming']['other']),
                  _buildSectionTitle('Sức khỏe'),
                  if (catBreed['health'] != null &&
                      catBreed['health']['genetic'] != null)
                    _buildText(catBreed['health']['genetic']),
                  if (catBreed['health'] != null &&
                      catBreed['health']['common'] != null)
                    _buildText(catBreed['health']['common']),
                  if (catBreed['health'] != null &&
                      catBreed['health']['checkups'] != null)
                    _buildText(catBreed['health']['checkups']),
                  _buildSectionTitle('Tính cách'),
                  if (catBreed['personality'] != null &&
                      catBreed['personality']['gentle'] != null)
                    _buildText(catBreed['personality']['gentle']),
                  if (catBreed['personality'] != null &&
                      catBreed['personality']['description'] != null)
                    _buildText(catBreed['personality']['description']),
                  if (catBreed['personality'] != null &&
                      catBreed['personality']['affectionate'] != null)
                    _buildText(catBreed['personality']['affectionate']),
                  if (catBreed['personality'] != null &&
                      catBreed['personality']['friendly'] != null)
                    _buildText(catBreed['personality']['friendly']),
                  if (catBreed['personality'] != null &&
                      catBreed['personality']['calm'] != null)
                    _buildText(catBreed['personality']['calm']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text),
    );
  }
}