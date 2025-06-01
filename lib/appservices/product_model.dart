  class Product {
    final String title;
    final String image;
    final int price;
    final String stock;
    final String description;

    Product({
      required this.title,
      required this.image,
      required this.price,
      required this.stock,
      required this.description
    });

    factory Product.fromMap(Map<String, dynamic> data) {
      return Product(
        title: data['title'] ?? '',
        image: data['image'] ?? '',
        price: data['price'] ?? 0,
        stock: data['stock'] ?? 'In Stock',
        description: data['description'] ?? '',
      );
    }

    Map<String, dynamic> toMap() {
      return {
        'title': title,
        'image': image,
        'price': price,
        'stock': stock,
        'description': description
      };
    }
  }
