import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/models/product.dart'; // Importa o modelo Product

// Classe ProductListTile que estende StatelessWidget para criar um tile de lista de produtos
class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    required this.product, // Construtor da classe ProductListTile
  });

  final Product product; // Declaração do produto

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Evento de clique
        Navigator.of(context).pushNamed(
          '/produtos',
          arguments: product,
        ); // Navega para a tela de detalhes do produto ao clicar
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(4.0), // Define o raio da borda do card
        ),
        child: Container(
          height: 150, // Define a altura do container
          padding: const EdgeInsets.all(16.0), // Define o padding do container
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1.0, // Mantém a proporção 1:1 para a imagem
                child: Image.network(
                  product.images.first, // Carrega a primeira imagem do produto
                  fit: BoxFit.cover, // Cobre todo o espaço disponível
                ),
              ),
              const SizedBox(
                width: 16.0, // Espaço entre a imagem e o texto
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Distribui os itens da coluna igualmente
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinha os itens à esquerda
                  children: [
                    Text(
                      product.name, // Nome do produto
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 19.0, // Estilo do texto
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 4.0), // Espaço superior
                      child: Text(
                        product.description, // Descrição do produto
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0, // Estilo do texto
                        ),
                        maxLines: 2, // Limita a duas linhas
                        overflow: TextOverflow
                            .ellipsis, // Trunca o texto se for muito longo
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 4.0), // Espaço superior
                      child: const Text(
                        "A partir de", // Texto adicional
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15.0, // Estilo do texto
                        ),
                      ),
                    ),
                    const Text(
                      "R\$ 19.99", // Preço do produto
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 19.0,
                        color: Colors.green, // Cor do texto
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
