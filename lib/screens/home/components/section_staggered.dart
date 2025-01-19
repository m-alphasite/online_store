import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Importa o pacote Staggered Grid View
import 'package:online_store/models/section.dart'; // Importa o modelo Section
import 'package:online_store/screens/home/components/item_tile.dart';
import 'package:online_store/screens/home/components/section_header.dart'; // Importa o componente SectionHeader

// Classe SectionStaggered que estende StatelessWidget para criar um layout em grade
class SectionStaggered extends StatelessWidget {
  final Section section; // Declaração do atributo section

  const SectionStaggered(
    this.section, {
    super.key,
  }); // Construtor da classe SectionStaggered

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8), // Define a margem horizontal e vertical do container
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinha os itens da coluna à esquerda
        children: <Widget>[
          SectionHeader(section), // Adiciona o cabeçalho da seção
          const SizedBox(
              height: 4), // Adiciona um espaçamento entre o cabeçalho e a grade
          MasonryGridView.count(
            // Usa o MasonryGridView com contagem de colunas
            padding: EdgeInsets.zero, // Remove o padding padrão
            crossAxisCount: 2, // Define o número de colunas
            itemCount:
                section.items.length, // Define o número de itens na grade
            itemBuilder: (_, index) => ItemTile(
              section.items[index], // Carrega os itens da seção
            ),
            mainAxisSpacing:
                4.0, // Espaçamento entre os itens na direção principal
            crossAxisSpacing:
                4.0, // Espaçamento entre os itens na direção cruzada
            shrinkWrap:
                true, // Define o comportamento de shrink para ajustar o tamanho
            physics:
                const NeverScrollableScrollPhysics(), // Desabilita a rolagem do grid
          ),
        ],
      ),
    );
  }
}
