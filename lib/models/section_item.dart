// Classe SectionItem que representa um item de uma seção
class SectionItem {
  SectionItem({
    required this.image, // URL da imagem
    this.product, // ID do produto, pode ser nulo
  });

  final String image; // Atributo que armazena a URL da imagem
  final String? product; // Atributo que armazena o ID do produto, pode ser nulo

  // Factory para criar uma instância de SectionItem a partir de um mapa
  factory SectionItem.fromMap(Map<String, dynamic> map) {
    return SectionItem(
      image: map['image'] as String, // Inicializa a URL da imagem
      product: map['product']
          as String?, // Inicializa o ID do produto, pode ser nulo
    );
  }

  // Método para converter a instância de SectionItem para uma string
  @override
  String toString() {
    return 'SectionItem{image: $image, product: $product}';
  }
}
