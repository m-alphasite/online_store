import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/models/user_manager.dart';
import 'package:online_store/models/cart_manager.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:online_store/screens/product/components/sizer_widget.dart';

class ProdutosScreen extends StatefulWidget {
  final Product product;

  const ProdutosScreen({
    super.key,
    required this.product,
  });

  @override
  _ProdutosScreenState createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.product),
        ChangeNotifierProvider(create: (_) => UserManager()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.product.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: MinhasCores.rosa_1,
          actions: [
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/edit_product',
                          arguments: widget.product);
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 390,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: widget.product.images.map((url) {
                      return Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.product.images.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        _currentIndex = entry.key;
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
                const SizedBox(height: 16),
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 26,
                    color: MinhasCores.rosa_3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "A partir de",
                    style: TextStyle(
                      fontSize: 17,
                      color: MinhasCores.rosa_1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FutureBuilder<num>(
                  future: widget.product.basePriceAsync,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        "Carregando...",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: MinhasCores.rosa_3,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        "Erro ao carregar preço",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      );
                    } else {
                      final preco = snapshot.data ?? 0;
                      if (preco == 0) {
                        return const Text(
                          "Sem estoque disponível",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        );
                      }

                      return Text(
                        "R\$ ${preco.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: MinhasCores.rosa_3,
                        ),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    "Descrição",
                    style: TextStyle(
                      fontSize: 16,
                      color: MinhasCores.rosa_1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.product.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: MinhasCores.rosa_3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    "Tamanhos",
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
                    return SizerWidget(size: size);
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Consumer2<UserManager, Product>(
                    builder: (_, userManager, product, ___) {
                      return ElevatedButton.icon(
                        onPressed: product.hasStock
                            ? () {
                                if (userManager.isLoggedIn) {
                                  context
                                      .read<CartManager>()
                                      .addToCart(widget.product);
                                  Navigator.pushNamed(context, '/cart');
                                } else {
                                  Navigator.pushNamed(context, '/login');
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MinhasCores.rosa_2,
                          minimumSize: const Size(200, 50),
                        ),
                        icon: const Icon(Icons.shopping_cart,
                            color: Colors.white),
                        label: Text(
                          userManager.isLoggedIn
                              ? 'Adicionar ao carrinho'
                              : 'Entrar para comprar',
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
