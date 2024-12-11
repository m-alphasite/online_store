import 'package:flutter/material.dart';
import 'package:online_store/common/price_card.dart';
import 'package:provider/provider.dart';
import 'package:online_store/models/cart_manager.dart';
import 'package:online_store/screens/cart/components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(builder: (_, cartManager, __) {
        return ListView(
          children: <Widget>[
            Column(
              children: cartManager.items.map((c) => CartTile(c)).toList(),
            ),
            PriceCard(),
          ],
        );
      }),
    );
  }
}
