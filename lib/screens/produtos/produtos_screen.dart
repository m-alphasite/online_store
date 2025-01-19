import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciamento de estado
import 'package:online_store/models/product.dart'; // Importa o modelo Product
import 'package:online_store/models/user_manager.dart'; // Importa o gerenciador de usuários
import 'package:online_store/models/cart_manager.dart'; // Importa o gerenciador de carrinho
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa as cores personalizadas
import 'package:carousel_slider/carousel_slider.dart'; // Importa o carrossel de imagens
import 'package:online_store/screens/product/components/sizer_widget.dart'; // Importa o widget de seleção de tamanho

// Classe ProdutosScreen que estende StatefulWidget para criar a tela de produtos
class ProdutosScreen extends StatefulWidget {
  final Product product; // Declaração do produto

  const ProdutosScreen({
    super.key,
    required this.product, // Construtor da classe ProdutosScreen
  });

  @override
  _ProdutosScreenState createState() =>
      _ProdutosScreenState(); // Cria o estado para a tela de produtos
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  int _currentIndex = 0; // Rastreia o índice atual do carrossel de imagens

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: widget.product, // Provedor do produto
        ),
        ChangeNotifierProvider(
          create: (_) => UserManager(), // Provedor do gerenciador de usuários
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white, // Define a cor de fundo do Scaffold
        appBar: AppBar(
          title: Text(
            widget.product
                .name, // Define o título da AppBar como o nome do produto
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), // Estilo do título
          ),
          centerTitle: true, // Centraliza o título
          backgroundColor: MinhasCores.rosa_1,
          actions: [
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/edit_product',
                          arguments: widget
                              .product); // Navega para a tela de edição do produto;
                    },
                  );
                }
                return Container();
              },
            ),
          ], // Cor de fundo da AppBar
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16), // Define o padding do conteúdo
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0, // Mantém a proporção da imagem
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 390,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex =
                              index; // Atualiza o índice atual do carrossel
                        });
                      },
                    ),
                    items: widget.product.images.map((url) {
                      return Image.network(
                        url, // Carrega a imagem do produto
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                    height: 16), // Espaço entre o carrossel e os indicadores
                // Indicador de Páginas
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.product.images.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        _currentIndex = entry.key; // Muda de página ao tocar
                      }),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? MinhasCores.rosa_2
                              : MinhasCores.rosa_3,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                    height:
                        16), // Espaço entre os indicadores e o nome do produto
                Text(
                  widget.product.name, // Exibe o nome do produto
                  style: TextStyle(
                    fontSize: 26,
                    color: MinhasCores.rosa_3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "A partir de", // Texto adicional
                    style: TextStyle(
                      fontSize: 17,
                      color: MinhasCores.rosa_1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "R\$ 19.99", // Exibe o preço do produto
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MinhasCores.rosa_3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    "Descrição", // Cabeçalho da descrição do produto
                    style: TextStyle(
                      fontSize: 16,
                      color: MinhasCores.rosa_1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.product.description, // Exibe a descrição do produto
                  style: TextStyle(
                    fontSize: 16,
                    color: MinhasCores.rosa_3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    "Tamanhos", // Cabeçalho dos tamanhos do produto
                    style: TextStyle(
                      fontSize: 16,
                      color: MinhasCores.rosa_1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.product.sizes.map((size) {
                    return SizerWidget(
                      size: size, // Exibe cada tamanho do produto
                    );
                  }).toList(),
                ),
                const SizedBox(
                    height: 16), // Espaço entre os tamanhos e o botão
                // Adicionando o ElevatedButton com UserManager e ícone de carrinho de compras
                Center(
                  child: Consumer2<UserManager, Product>(
                    builder: (_, userManager, product, ___) {
                      // Verifica se há estoque disponível para o produto
                      return ElevatedButton.icon(
                        // Desabilita o botão se nenhum tamanho estiver selecionado ou se não houver estoque
                        onPressed: product.hasStock
                            ? () {
                                if (userManager.isLoggedIn) {
                                  // Adiciona o produto ao carrinho
                                  context.read<CartManager>().addToCart(widget
                                      .product); // Adiciona o produto ao carrinho
                                  Navigator.pushNamed(context,
                                      '/cart'); // Redireciona para a tela de carrinho
                                } else {
                                  // Redireciona para a tela de login
                                  Navigator.pushNamed(context, '/login');
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MinhasCores.rosa_2,
                          minimumSize: const Size(200, 50),
                        ),
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white, // Ícone de carrinho de compras
                        ),
                        label: Text(
                          userManager.isLoggedIn
                              ? 'Adicionar ao carrinho'
                              : 'Entrar para comprar', // Texto do botão
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
