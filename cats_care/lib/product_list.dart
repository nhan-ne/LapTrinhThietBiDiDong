import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<dynamic> products = [];

  Future<void> loadProducts() async {
    try{
      String jsonString = await rootBundle.loadString('assets/products.json');
      setState(() {
      products = json.decode(jsonString);
      });
    }catch(e){
      print('Error loading product_list: $e');
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title:Text('Sản phẩm',
          style:TextStyle(
            color: Colors.black, 
            fontSize: 28,
            fontWeight: FontWeight.bold,
          )
        ),
      ),
      body: Padding(
        padding:EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Một số sản phẩm tham khảo giúp thú cưng của anh chị em trở nên ú nụ',
              style:TextStyle(
                color:Colors.black,
                fontSize: 14, 
              )
            ),
            SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.55,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                products[index]['image']!,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),

                          Text(
                            products[index]['name']!,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),

                          Text(
                              products[index]['describe']!,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Spacer(),

                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber
                            ),
                            child: Text('Chi tiết'),
                          ),
                        ],
                      ),
                    )
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}