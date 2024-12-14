// Classe SectionItem que representa um item de uma seção
class SectionItem {
  SectionItem({
    required this.image, // URL da imagem
  });

  final String image; // Atributo que armazena a URL da imagem

  // Factory para criar uma instância de SectionItem a partir de um mapa
  factory SectionItem.fromMap(Map<String, dynamic> map) {
    return SectionItem(
      image: map['image'] as String, // Inicializa a URL da imagem
    );
  }

  // Método para converter a instância de SectionItem para uma string
  @override
  String toString() {
    return 'SectionItem{image: $image}';
  }
}
