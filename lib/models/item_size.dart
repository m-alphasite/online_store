class ItemSize {
  // Define a classe ItemSize
  ItemSize({
    // Construtor
    required this.name, // Nome do item
    required this.price, // Preço do item
    required this.stock, // Estoque do item
  });

  late final String name; // Nome do item
  late final num price; // Preço do item
  late final int stock; // Estoque do item

  // Propriedade para verificar se há estoque disponível
  bool get hasStock => stock > 0;

  // Construtor a partir de um mapa
  ItemSize.fromMap(Map<String, dynamic> map)
      : name = map['name'] as String, // Nome do item
        price = map['price'] as num, // Preço do item
        stock = map['stock'] as int; // Estoque do item

  // Método para converter a instância para um mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name, // Nome do item
      'price': price, // Preço do item
      'stock': stock, // Estoque do item
    };
  }

  @override
  String toString() {
    // Sobrescreve o método toString para retornar uma string com as propriedades do item
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }
}
