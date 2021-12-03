import 'package:rxdart/rxdart.dart';
import 'package:stream_sample/firestore_rxdart_bloc_pattern/product_model.dart';

class BasketBloc {
  List<ProductModel> basketItems = [];

  late BehaviorSubject<List<ProductModel>> _subjectBasket;

  BasketBloc() {
    _subjectBasket = BehaviorSubject<List<ProductModel>>.seeded(basketItems);
  }

  Stream<List<ProductModel>> get basketItemsObs => _subjectBasket.stream;

  void increment(
    ProductModel product,
  ) {
    final _itemIndex = basketItems.indexWhere((e) => e.id == product.id);

    //item not found
    if (_itemIndex.isNegative) {
      basketItems.add(product);
    } else {
      final _item = basketItems[_itemIndex];
      _item.qty++;
    }
    _subjectBasket.sink.add(basketItems);
  }

  void decrement(ProductModel product) {
    final _itemIndex = basketItems.indexWhere((e) => e.id == product.id);

    //item not found
    if (_itemIndex.isNegative) {
      basketItems.add(product);
    } else {
      final _item = basketItems[_itemIndex];
      _item.qty--;
    }
    _subjectBasket.sink.add(basketItems);
  }
}
