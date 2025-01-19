import 'package:flutter/material.dart'; // Importa o pacote Flutter para construir a interface do usuário

// Classe que cria um botão personalizado
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key, // Chave do widget
    required this.iconData, // Ícone do botão
    this.onTap, // Função a ser executada ao clicar no botão
    required this.color, // Cor do ícone
  });

  final IconData iconData; // Declaração do ícone
  final Color color; // Declaração da cor
  final VoidCallback? onTap; // Declaração da função ao clicar

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Widget que permite recortar bordas com raios circulares
      borderRadius: BorderRadius.circular(50.0), // Define o raio das bordas
      child: Material(
        // Cria um Material
        color: Colors.transparent, // Define a cor do Material como transparente
        child: InkWell(
          // Cria um InkWell para detectar toques
          onTap: onTap, // Define a função ao clicar
          child: Padding(
            // Adiciona um padding ao redor do ícone
            padding: const EdgeInsets.all(5.0), // Define o tamanho do padding
            child: Icon(
              // Cria um ícone
              iconData, // Define o ícone
              color: color, // Define a cor do ícone
            ),
          ),
        ),
      ),
    );
  }
}
