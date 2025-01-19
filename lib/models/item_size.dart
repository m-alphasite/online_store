class ItemSize {
  // Construtor
  ItemSize({
    required this.name,
    required this.price,
    required this.stock,
  });

  String name; // Nome do item, agora modificável
  num price; // Preço do item, agora modificável
  int stock; // Estoque do item, agora modificável

  // Propriedade para verificar se há estoque disponível
  bool get hasStock => stock > 0;

  // Construtor a partir de um mapa
  ItemSize.fromMap(Map<String, dynamic> map)
      : name = map['name'] as String,
        price = map['price'] as num,
        stock = map['stock'] as int;

  // Método para converter a instância para um mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
    };
  }

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }
}
