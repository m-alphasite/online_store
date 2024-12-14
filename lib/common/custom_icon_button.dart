import 'package:flutter/material.dart'; // Importa o pacote Flutter para construir a interface do usuário

// Classe que cria um botão personalizado
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key, // Construtor
    required this.iconData, // Ícone
    this.onTap, // Função ao clicar
    required this.color, // Cor
  });

  final IconData iconData; // Ícone
  final Color color; // Cor
  final VoidCallback? onTap; // Função ao clicar

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Material(
        // Cria um material
        color: Colors.transparent, // Cor transparente
        child: InkWell(
          // Cria um InkWell
          onTap: onTap, // Função ao clicar
          child: Padding(
            // Cria um padding
            padding: const EdgeInsets.all(5.0), // Define o padding
            child: Icon(
              // Cria um ícone
              iconData, // Ícone
              color: color, // Cor
            ),
          ),
        ),
      ),
    );
  }
}
