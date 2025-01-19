import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces

// Classe SearchDialog que estende StatelessWidget para criar uma caixa de diálogo de busca
class SearchDialog extends StatelessWidget {
  const SearchDialog({
    super.key,
    required this.initialText, // Construtor da classe SearchDialog
  });

  final String initialText; // Declaração do texto inicial

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          // Posiciona o campo de texto dentro da caixa de diálogo
          top: 18, // Posiciona o campo de texto acima da caixa de diálogo
          left: 4, // Posiciona o campo de texto à esquerda da caixa de diálogo
          right: 4, // Posiciona o campo de texto à direita da caixa de diálogo
          child: Card(
            // Cria um Card para o campo de texto
            child: TextFormField(
              initialValue:
                  initialText, // Define o valor inicial do campo de texto
              textInputAction: TextInputAction
                  .search, // Define a ação do botão de teclado como "search"
              decoration: InputDecoration(
                border: InputBorder.none, // Remove a borda do campo de texto
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15), // Define o padding vertical
                prefixIcon: IconButton(
                  onPressed: () => Navigator.of(context)
                      .pop(), // Fecha a caixa de diálogo ao clicar no ícone
                  icon: Icon(
                    Icons.arrow_back, // Ícone de seta para voltar
                    size: 24, // Tamanho do ícone
                    color: Colors.grey[700], // Cor do ícone
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    // Implementar funcionalidade de limpar aqui, se necessário
                  },
                  icon: Icon(
                    Icons.close, // Ícone de fechar
                    size: 24, // Tamanho do ícone
                    color: Colors.grey[700], // Cor do ícone
                  ),
                ),
                isDense: true, // Define a densidade do campo de texto
              ),
              onFieldSubmitted: (text) {
                Navigator.of(context).pop(
                    text); // Fecha a caixa de diálogo e retorna o texto digitado ao enviar
              },
            ),
          ),
        ),
      ],
    );
  }
}
