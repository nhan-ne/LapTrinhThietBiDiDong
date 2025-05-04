import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/catbreeds/cat_breeds_view_model.dart';
import 'cat_breed_detail_screen.dart';

class CatBreedsScreen extends StatefulWidget {
  @override
  _CatBreedsScreenState createState() => _CatBreedsScreenState();
}

class _CatBreedsScreenState extends State<CatBreedsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CatBreedsViewModel>(context, listen: false).loadCatBreeds();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<CatBreedsViewModel>().filterCatBreeds(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CatBreedsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('GIỐNG MÈO'),
        backgroundColor: const Color(0xff7FDDE5),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: viewModel.filteredCatBreeds.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 157 / 200,
              ),
              itemCount: viewModel.filteredCatBreeds.length,
              itemBuilder: (context, index) {
                final catBreed = viewModel.filteredCatBreeds[index];
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 170,
                          height: 190,
                          child: Image.asset(
                            catBreed['imageUrl'],
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            catBreed['name'],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}