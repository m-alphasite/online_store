class SectionItem {
  SectionItem({
    required this.image,
  });

  final String image; // Imagem

  factory SectionItem.fromMap(Map<String, dynamic> map) {
    return SectionItem(
      image: map['image'] as String, // Imagem
    );
  }

  @override
  String toString() {
    return 'SectionItem{image: $image}';
  }
}
