import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils.dart';
import 'detail_basket_page.dart';
import 'product_model.dart';
import 'utils.dart';

class MainTestingPage extends StatefulWidget {
  const MainTestingPage({Key? key}) : super(key: key);

  @override
  _MainTestingPageState createState() => _MainTestingPageState();
}

class _MainTestingPageState extends State<MainTestingPage> {
  List<ProductModel> items = [];

  @override
  void initState() {
    items.add(ProductModel.json({
      "name": "Ketchup",
      "price": 9000,
      "qty": 200,
    }));
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: products.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final _data = snapshot.data!.docs;
                      return Column(
                        children: _data.map((e) {
                          final _item = ProductModel(
                              id: e.id,
                              name: e['name'],
                              price: e['price'],
                              qty: e['qty']);
                          return ItemCard(
                            e: _item,
                          );
                        }).toList(),
                      );
                    }

                    if (snapshot.hasError) return const Text("Error...");

                    return const CircularProgressIndicator();
                  }),
            ),
            const Divider(color: Colors.black),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Basket"),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetailBasketPage(),
                        ),
                      );
                    },
                    child: StreamBuilder<List<ProductModel>>(
                        stream: basket.basketItemsObs,
                        builder: (context, snapshot) {
                          return Text("Cart ${snapshot.data!.length}");
                        }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final ProductModel e;
  const ItemCard({
    Key? key,
    required this.e,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(e.name),
          Text("Rp${e.price}"),
          Row(
            children: [
              Text("qty: ${e.qty}"),
              IconButton(
                  color: Colors.blue,
                  onPressed: () {
                    final _data = e;
                    _data.qty = 1;
                    basket.increment(_data);
                  },
                  icon: const Icon(Icons.add_shopping_cart)),
            ],
          ),
        ],
      ),
    );
  }
}
