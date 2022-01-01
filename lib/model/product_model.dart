class ProductModel {
  String id;
  String name;
  int price;
  int qty;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
  });

  factory ProductModel.json(x) {
    return ProductModel(
      id: x['id'] ?? "",
      name: x['name'] ?? "",
      price: x['price'] ?? 0,
      qty: x['qty'] ?? 0,
    );
  }
}
