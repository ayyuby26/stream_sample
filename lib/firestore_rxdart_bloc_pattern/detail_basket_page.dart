import 'package:flutter/material.dart';
import 'package:stream_sample/firestore_rxdart_bloc_pattern/product_model.dart';
import 'package:stream_sample/firestore_rxdart_bloc_pattern/utils.dart';
import 'package:stream_sample/utils.dart';

class DetailBasketPage extends StatefulWidget {
  const DetailBasketPage({Key? key}) : super(key: key);

  @override
  _DetailBasketPageState createState() => _DetailBasketPageState();
}

class _DetailBasketPageState extends State<DetailBasketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ProductModel>>(
                  stream: basket.basketItemsObs,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      if (snapshot.data!.isNotEmpty) {
                        return SingleChildScrollView(
                          child: Column(
                            children: snapshot.data!.map((e) {
                              return ItemDetailCard(e: e);
                            }).toList(),
                          ),
                        );
                      }
                      return const Center(
                        child: Text("tidak ada produk di basket"),
                      );
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
            const Divider(color: Colors.black),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<List<ProductModel>>(
                      stream: basket.basketItemsObs,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          final _data = snapshot.data!;
                          int _total = 0;
                          for (var element in _data) {
                            _total += element.qty * element.price;
                          }
                          return Text("Total: $_total");
                        }

                        return const CircularProgressIndicator();
                      }),
                  StreamBuilder<List<ProductModel>>(
                      stream: basket.basketItemsObs,
                      builder: (context, snapshot) {
                        return ElevatedButton(
                          onPressed: () {
                            if (snapshot.data != null) {
                              for (var e in snapshot.data!) {
                                products.doc(e.id).update({"qty": e.qty});
                              }
                            }
                          },
                          child: const Text("Bayar"),
                        );
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ItemDetailCard extends StatelessWidget {
  final ProductModel e;
  const ItemDetailCard({
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
              IconButton(
                color: Colors.red,
                onPressed: () {
                  basket.decrement(e);
                },
                icon: const Icon(Icons.remove_circle),
              ),
              Text("${e.qty}"),
              IconButton(
                color: Colors.green,
                onPressed: () {
                  basket.increment(e);
                },
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
