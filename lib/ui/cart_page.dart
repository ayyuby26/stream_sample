import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stream_sample/model/product_model.dart';
import 'package:stream_sample/utils/utils.dart';
import 'package:stream_sample/widgets/widgets.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  _convertData(List<QueryDocumentSnapshot<Object?>> data) {
    return data.map((e) {
      final _item = ProductModel(
        id: e.id,
        name: e['name'],
        price: e['price'],
        qty: e['qty'],
      );
      return _item;
    }).toList();
  }

  _streamProductsCart(List<ProductModel> _products) {
    return StreamBuilder<List<ProductModel>>(
        stream: cartBloc.itemsInCartObs,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data!.isNotEmpty) {
              final _productsCart = snapshot.data!;
              return SuccessLoad(
                productsCart: _productsCart,
                products1: _products,
              );
            }
            return const Center(
              child: Text("tidak ada produk di keranjang"),
            );
          }
          return const CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: products.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final _products = _convertData(snapshot.data!.docs);
                return _streamProductsCart(_products);
              }
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}

class SuccessLoad extends StatelessWidget {
  final List<ProductModel> productsCart;
  final List<ProductModel> products1;

  const SuccessLoad({
    Key? key,
    required this.productsCart,
    required this.products1,
  }) : super(key: key);

  _payAct(
    BuildContext context,
    List<ProductModel> _productsCart,
    List<ProductModel> _products,
  ) {
    for (var e in _productsCart) {
      for (var e1 in _products) {
        if (e.id == e1.id) {
          products.doc(e.id).update(
            {"qty": e1.qty - e.qty},
          ).then((value) {
            cartBloc.deleteProduct(e);
          });
        }
      }
    }
    Navigator.pop(context);
    Widgets.showSnackBar(context, "sukses bayar");
  }

  _priceCount(List<ProductModel> _productsCart) {
    int _total = 0;
    for (var element in _productsCart) {
      _total += element.qty * element.price;
    }
    return currencyFormat(_total);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: productsCart.map((e) {
                return ItemDetailCard(e: e, products: products1);
              }).toList(),
            ),
          ),
        ),
        const Divider(color: Colors.black),
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total: Rp ${_priceCount(productsCart)}"),
              ElevatedButton(
                onPressed: () => _payAct(context, productsCart, products1),
                child: const Text("Bayar"),
              )
            ],
          ),
        )
      ],
    );
  }
}

class ItemDetailCard extends StatelessWidget {
  final List<ProductModel> products;

  final ProductModel e;
  const ItemDetailCard({
    Key? key,
    required this.e,
    required this.products,
  }) : super(key: key);

  _decrementAct(BuildContext context) {
    if (e.qty == 1) {
      // showSnackBar(context, 'minimal 1 pcs');
    } else {
      cartBloc.changeQty(product: e, isIncrement: false);
    }
  }

  _incrementAct(BuildContext context) {
    final _itemCloud = products.firstWhere((e1) => e1.id == e.id);
    if (e.qty >= _itemCloud.qty) {
      const _msg = 'anda sudah dibatas maksimal pembelian';
      // showSnackBar(context, _msg);
    } else {
      cartBloc.changeQty(product: e, isIncrement: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(e.name),
          Text("Rp ${currencyFormat(e.price)}"),
          Row(
            children: [
              IconButton(
                color: Colors.red,
                onPressed: () => _decrementAct(context),
                icon: const Icon(Icons.remove_circle),
              ),
              Text("${e.qty}"),
              IconButton(
                color: Colors.green,
                onPressed: () => _incrementAct(context),
                icon: const Icon(Icons.add_circle),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => cartBloc.deleteProduct(e),
                icon: const Icon(
                  Icons.highlight_remove,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
