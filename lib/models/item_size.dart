class ItemSize {
  // Defina a classe ItemSize
  ItemSize({
    // Construtor
    required this.name, // Nome do item
    required this.price, // Preço do item
    required this.stock, // Estoque do item
  });

  final String name; // Nome do item
  final num price; // Preço do item
  final int stock; // Estoque do item

  bool get hasStock => stock > 0; // Verifique se o estoque é maior que zero

  ItemSize.fromMap(Map<String, dynamic> map) // Construtor a partir de um mapa
      : name = map['name'] as String, // Nome do item
        price = map['price'] as num, // Preço do item
        stock = map['stock'] as int; // Estoque do item

  Map<String, dynamic> toMap() {
    // Converta a instância para um mapa
    return {
      'name': name, // Nome do item
      'price': price, // Preço do item
      'stock': stock, // Estoque do item
    };
  }

  @override
  String toString() {
    // Sobrescreva o método toString
    return 'ItemSize{name: $name, price: $price, stock: $stock}'; // Retorne uma string com as propriedades do item
  }
}
