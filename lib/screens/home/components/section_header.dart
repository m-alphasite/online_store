import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/models/section.dart'; // Importa o modelo Section

// Classe SectionHeader que estende StatelessWidget para criar um cabeçalho de seção
class SectionHeader extends StatelessWidget {
  final Section section; // Declaração do atributo section

  const SectionHeader(
    this.section, {
    super.key,
  }); // Construtor da classe SectionHeader

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8), // Define o padding vertical do cabeçalho
      child: Text(
        section.name, // Exibe o nome da seção
        style: const TextStyle(
          color: Colors.white, // Define a cor do texto como branco
          fontSize: 18, // Define o tamanho da fonte
          fontWeight: FontWeight.w800, // Define o peso da fonte
        ),
      ),
    ); // Exibe o título da seção
  }
}
