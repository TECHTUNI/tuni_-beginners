class ProductCategory {
  final String id;
  final String name;
  final String brand;
  final String gender;
  final String price;
  final String time;
  final List<dynamic> imageUrlList;
  final String quantity;
  final String color;
  final List<dynamic> size;

  ProductCategory({
    required this.id,
    required this.name,
    required this.brand,
    required this.gender,
    required this.price,
    required this.time,
    required this.imageUrlList,
    required this.quantity,
    required this.color,
    required this.size,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      gender: json['gender'] ?? '',
      price: json['price'] ?? '',
      time: json['time'] ?? '',
      imageUrlList: json['imageUrl'] ?? [],
      quantity: json['Quantity'] ?? '',
      color: json['color'] ?? '',
      size: json['size'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'gender': gender,
      'price': price,
      'time': time,
      'imageUrl': imageUrlList,
      'Quantity': quantity,
      'color': color,
      'size': size,
    };
  }
}
