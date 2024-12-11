import 'package:flutter/material.dart'; // Import the Flutter library
import 'package:online_store/common/price_card.dart'; // Import the PriceCard widget
import 'package:provider/provider.dart'; // Import the Provider package
import 'package:online_store/models/cart_manager.dart'; // Import the CartManager
import 'package:online_store/screens/cart/components/cart_tile.dart'; // Import the CartTile widget

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Override the build method
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'), // Set the title of the AppBar
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          // Consumer para obter o CartManager
          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items
                    .map((c) => CartTile(c))
                    .toList(), // Mapeia os itens do carrinho para o CartTile
              ),
              PriceCard(
                buttonText: 'Continuar para a Entrega',
                onPressed: cartManager.isCartValid
                    ? () {
                        Navigator.of(context).pushNamed('/address');
                      }
                    : null, // Define o botão de acordo com a validade do carrinho
              ), // Exibe o PriceCard
            ],
          );
        },
      ),
    );
  }
}
