import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stream_sample/model/product_model.dart';
import 'package:stream_sample/utils/utils.dart';
import 'cart_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Produk")),
      body: SafeArea(
        child: Column(
          children: const [
            Expanded(child: StreamProducts()),
            Divider(color: Colors.black),
            BottomWidget()
          ],
        ),
      ),
    );
  }
}

class BottomWidget extends StatelessWidget {
  const BottomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: () => movePage(context, const CartPage()),
            child: StreamBuilder<List<ProductModel>>(
                stream: cartBloc.itemsInCartObs,
                builder: (context, snapshot) {
                  final _data = snapshot.hasData ? snapshot.data!.length : '';
                  return Text("Keranjang $_data");
                }),
          )
        ],
      ),
    );
  }
}

class StreamProducts extends StatelessWidget {
  const StreamProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    List _product_list(_data) {
      return _data.map((e) {
        final _item = ProductModel(
          id: e.id,
          name: e['name'],
          price: e['price'],
          qty: e['qty'],
        );
        return ItemCard(product: _item);
      }).toList();
    }

    return StreamBuilder<QuerySnapshot>(
        stream: products.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final _data = snapshot.data!.docs;
            final _product = _product_list(_data);
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _product.length,
              itemBuilder: (context, index) {
                return _product[index];
              },
            );
          }
          if (snapshot.hasError) return const Text("Error...");
          return const CircularProgressIndicator();
        });
  }
}

class ItemCard extends StatelessWidget {
  final ProductModel product;
  // ignore: use_key_in_widget_constructors
  const ItemCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(product.name),
          Text("Rp ${currencyFormat(product.price)}"),
          Row(
            children: [
              Text("qty: ${product.qty}"),
              IconButton(
                  color: Colors.blue,
                  onPressed: () {
                    final _data = product;
                    _data.qty = 1;
                    cartBloc.changeQty(product: _data, isIncrement: true);
                  },
                  icon: const Icon(Icons.add_shopping_cart)),
            ],
          ),
        ],
      ),
    );
  }
}
