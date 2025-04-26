import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'cat_breed_detail_screen.dart';

class CatBreedsScreen extends StatefulWidget {
  const CatBreedsScreen ({super.key});
  
  @override
  State<CatBreedsScreen> createState() => _CatBreedsScreenState();
}

class _CatBreedsScreenState extends State<CatBreedsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _originalCatBreeds = [];
  List<dynamic> _filteredCatBreeds = [];

  Future<String> _loadCatBreedsAsset() async {
    return await rootBundle.loadString('assets/cat_breeds.json');
  }

  Future<List<dynamic>> _loadCatBreeds() async {
    try {
      String jsonString = await _loadCatBreedsAsset();
      final data = json.decode(jsonString);
      return data;
    } catch (e) {
      print('Error loading cat breeds: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCatBreeds().then((breeds) {
      setState(() {
        _originalCatBreeds = breeds;
        _filteredCatBreeds = breeds;
      });
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _filteredCatBreeds = _originalCatBreeds;
      } else {
        _filteredCatBreeds = _originalCatBreeds
            .where((breed) =>
            (breed['name'] as String)
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giống mèo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all( 16),
        child:Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
            SizedBox(height: 20,),
            
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _loadCatBreeds(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.67,
                      ),
                      itemCount: _filteredCatBreeds.length,
                      itemBuilder: (context, index) {
                        final catBreed = _filteredCatBreeds[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CatBreedDetailScreen(catBreed: catBreed),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    catBreed['imageUrl']!,
                                    height: 190,
                                    width: 170,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    catBreed['name'],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Đã xảy ra lỗi'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}