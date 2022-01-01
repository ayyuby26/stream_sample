import 'package:rxdart/rxdart.dart';
import '../model/product_model.dart';

class CartBloc {
  // ignore: prefer_final_fields
  List<ProductModel> _itemsInCart = [];
  late BehaviorSubject<List<ProductModel>> _subjectCart;

  CartBloc() {
    _subjectCart = BehaviorSubject<List<ProductModel>>.seeded(_itemsInCart);
  }

  Stream<List<ProductModel>> get itemsInCartObs => _subjectCart.stream;

  void changeQty({required ProductModel product, required bool isIncrement}) {
    final _itemIndex = _itemsInCart.indexWhere((e) => e.id == product.id);

    //item not found
    if (_itemIndex.isNegative) {
      _itemsInCart.add(product);
    } else {
      final _item = _itemsInCart[_itemIndex];
      isIncrement ? _item.qty++ : _item.qty--;
    }
    _subjectCart.sink.add(_itemsInCart);
  }

  void deleteProduct(ProductModel product) {
    final _item = _itemsInCart.firstWhere((e) => e.id == product.id);
    _itemsInCart.remove(_item);
    _subjectCart.sink.add(_itemsInCart);
  }
}
