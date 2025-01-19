import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa o arquivo de cores personalizadas
import 'package:online_store/common/price_card.dart'; // Importa o PriceCard widget
import 'package:provider/provider.dart'; // Importa o pacote Provider para gerenciamento de estado
import 'package:online_store/models/cart_manager.dart'; // Importa o CartManager
import 'package:online_store/screens/cart/components/cart_tile.dart'; // Importa o CartTile widget

// Classe CartScreen que estende StatelessWidget
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Método build que cria a interface do usuário
    return Scaffold(
      backgroundColor: MinhasCores.rosa_1, // Define a cor de fundo do Scaffold
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              'Pandora Fashion', // Título da AppBar
              style:
                  TextStyle(color: Colors.white), // Estilo do texto do título
            ),
          ],
        ),
        centerTitle: true, // Centraliza o título
        backgroundColor: Colors
            .transparent, // Define a cor de fundo da AppBar como transparente
        elevation: 0, // Remove a sombra da AppBar
        toolbarHeight: 80.0, // Define a altura da AppBar
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12.0), // Define o raio de borda inferior
          ),
        ),
      ),
      body: Consumer<CartManager>(
        // Consumer para obter o CartManager
        builder: (_, cartManager, __) {
          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items
                    .map((c) => CartTile(c))
                    .toList(), // Mapeia os itens do carrinho para o CartTile
              ),
              PriceCard(
                buttonText: 'Continuar para a Entrega', // Texto do botão
                onPressed: cartManager.isCartValid
                    ? () {
                        Navigator.of(context).pushNamed(
                            '/address'); // Navega para a página de endereço se o carrinho for válido
                      }
                    : null, // Define o botão como nulo se o carrinho não for válido
              ), // Exibe o PriceCard
            ],
          );
        },
      ),
    );
  }
}
