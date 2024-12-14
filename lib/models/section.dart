import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_store/models/section_item.dart'; // Importa a classe SectionItem

class Section {
  // Declara a classe Section
  Section.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    name = data['name'] as String; // Acessa o valor usando a chave correta
    type = data['type'] as String; // Acessa o valor usando a chave correta

    items = (data['items'] as List<dynamic>)
        .map((item) => SectionItem.fromMap(item as Map<String, dynamic>))
        .toList(); // Mapeia os itens corretamente para SectionItem
  }

  late String name; // Declara a variável como late para inicialização posterior
  late String type; // Declara a variável como late para inicialização posterior
  late List<SectionItem>
      items; // Declara a lista como late para inicialização posterior

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
