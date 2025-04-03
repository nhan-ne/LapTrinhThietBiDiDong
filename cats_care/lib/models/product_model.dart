class ProductModel {
  final String name;
  final String describe;
  final String image;

  ProductModel({required this.name, required this.describe, required this.image});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      describe: json['describe'],
      image: json['image'],
    );
  }
}
