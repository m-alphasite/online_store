import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o Firestore do Firebase para interagir com o banco de dados
import 'package:online_store/models/section_item.dart'; // Importa a classe SectionItem

// Classe Section que representa uma seção
class Section {
  // Construtor que cria uma instância de Section a partir de um DocumentSnapshot do Firestore
  Section.fromDocument(DocumentSnapshot document) {
    // Converte os dados do documento para um Map
    final data = document.data() as Map<String, dynamic>;
    name = data['name'] as String; // Inicializa o nome da seção
    type = data['type'] as String; // Inicializa o tipo da seção

    // Inicializa a lista de itens da seção mapeando os dados para SectionItem
    items = (data['items'] as List<dynamic>)
        .map((item) => SectionItem.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  late String name; // Nome da seção
  late String type; // Tipo da seção
  late List<SectionItem> items; // Lista de itens da seção

  // Método para converter a instância de Section para uma string
  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
