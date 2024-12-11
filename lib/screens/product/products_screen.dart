import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/common/custom_drawer/custom_drawer.dart'; // Importa o drawer personalizado
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa as cores personalizadas
import 'package:online_store/models/product_manager.dart'; // Importa o gerenciador de produtos
import 'package:online_store/screens/product/components/product_list_tile.dart'; // Importa o componente de lista de produtos
import 'package:online_store/screens/product/components/search_dialog.dart'; // Importa o componente de diálogo de busca
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciamento de estado

// Classe ProductsScreen que estende StatelessWidget para criar a tela de produtos
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MinhasCores.rosa_1, // Define a cor de fundo do Scaffold
      drawer: const CustomDrawer(), // Adiciona o drawer personalizado
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu), // Ícone de menu
            color: Colors.white, // Cor do ícone
            onPressed: () => Scaffold.of(context)
                .openDrawer(), // Abre o drawer ao clicar no ícone de menu
          );
        }),
        title: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            if (productManager.search == null ||
                productManager.search!.isEmpty) {
              return const Text(
                "Produtos\nCamisetas", // Título da AppBar
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else {
              return GestureDetector(
                onTap: () async {
                  final search = await showDialog<String>(
                    context: context,
                    builder: (_) => SearchDialog(
                        initialText:
                            productManager.search!), // Abre o diálogo de busca
                  );
                  if (search != null) {
                    productManager.search = search; // Atualiza o termo de busca
                  }
                },
                child: Text(
                  productManager.search!,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              );
            }
          },
        ),
        centerTitle: true, // Centraliza o título
        backgroundColor: MinhasCores.rosa_2, // Define a cor de fundo da AppBar
        elevation: 0, // Remove a sombra da AppBar
        toolbarHeight: 90.0, // Define a altura da AppBar
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12.0), // Define o raio de borda inferior
          ),
        ),
        actions: [
          Consumer<ProductManager>(
            builder: (_, productManager, __) {
              if (productManager.search == null ||
                  productManager.search!.isEmpty) {
                return IconButton(
                  onPressed: () async {
                    final search = await showDialog<String>(
                      context: context,
                      builder: (_) => const SearchDialog(
                          initialText:
                              ''), // Abre o diálogo de busca com texto vazio
                    );
                    if (search != null) {
                      context.read<ProductManager>().search =
                          search; // Atualiza o termo de busca
                    }
                  },
                  icon: const Icon(
                    Icons.search, // Ícone de busca
                    color: Colors.white,
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    context.read<ProductManager>().search =
                        ''; // Limpa o termo de busca
                  },
                  icon: const Icon(
                    Icons.close, // Ícone de fechar
                    color: Colors.white,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          final filteredProducts =
              productManager.filteredProducts; // Obtém os produtos filtrados
          return ListView.builder(
            padding: const EdgeInsets.all(4.0), // Define o padding do ListView
            itemCount:
                filteredProducts.length, // Define o número de itens na lista
            itemBuilder: (_, index) {
              return ProductListTile(
                product: filteredProducts[
                    index], // Adiciona um tile de produto para cada item filtrado
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            MinhasCores.rosa_2, // Define a cor de fundo do FloatingActionButton
        foregroundColor:
            Colors.white, // Define a cor do texto do FloatingActionButton
        onPressed: () => Navigator.of(context).pushNamed(
            '/cart'), // Abre a tela de carrinho ao clicar no FloatingActionButton
        child: const Icon(Icons.shopping_cart), // Ícone de carrinho
      ),
    );
  }
}
