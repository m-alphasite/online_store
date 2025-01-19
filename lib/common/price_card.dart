import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa as cores personalizadas
import 'package:online_store/models/cart_manager.dart'; // Importa o gerenciador de carrinho
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciar o estado

// Classe PriceCard que estende StatelessWidget
class PriceCard extends StatelessWidget {
  const PriceCard({
    super.key,
    required this.buttonText, // Texto do botão
    required this.onPressed, // Função a ser executada ao clicar no botão
  });

  final String buttonText; // Declaração do texto do botão
  final VoidCallback?
      onPressed; // Declaração da função a ser executada ao clicar (opcional)

  @override
  Widget build(BuildContext context) {
    // Método build que cria a interface do usuário

    final cartManager = context.watch<CartManager>(); // Observa o CartManager
    final productPrice = cartManager
        .productsPrice; // Obtém o preço total dos produtos no carrinho

    return Card(
      // Cria um Card
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ), // Define o espaçamento do Card
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16.0,
          16.0,
          16.0,
          4.0,
        ), // Define o espaçamento interno do Card
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Alinha os elementos da coluna
          children: <Widget>[
            Text(
              'Resumo do pedido', // Título do Card
              textAlign: TextAlign.start, // Alinha o texto ao início
              style: TextStyle(
                fontSize: 16.0, // Define o tamanho da fonte
                fontWeight: FontWeight.w600, // Define o peso da fonte
              ),
            ),
            const SizedBox(height: 12.0), // Espaçamento vertical
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Alinha os elementos da linha
              children: <Widget>[
                Text(
                  'Subtotal', // Texto para o subtotal
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(), // Espaçamento flexível entre o texto e o valor
                Text(
                  'R\$ ${productPrice.toStringAsFixed(2)}', // Exibe o preço dos produtos
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(), // Adiciona um divisor
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Entrega', // Texto para a entrega
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  'R\$ 12,00', // Exibe o valor da entrega
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(), // Adiciona um divisor
            const SizedBox(height: 12.0), // Espaçamento vertical
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total', // Texto para o total
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  'R\$ ${(productPrice + 12.00).toStringAsFixed(2)}', // Exibe o preço total (produtos + entrega)
                  style: TextStyle(
                    fontSize: 16.0,
                    color: MinhasCores.rosa_3, // Cor do texto
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0), // Espaçamento vertical
            ElevatedButton(
              // Cria um botão elevado
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cor de fundo do botão
                foregroundColor: Colors.white, // Cor do texto do botão
                disabledBackgroundColor:
                    Colors.grey, // Cor de fundo quando o botão está desativado
                disabledForegroundColor:
                    Colors.white, // Cor do texto quando o botão está desativado
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      18.0), // Define o raio das bordas do botão
                ),
              ),
              onPressed:
                  onPressed, // Define a função a ser executada ao clicar no botão
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centraliza os elementos dentro do botão
                children: [
                  Icon(
                    Icons.location_on, // Ícone de endereço
                    color: Colors.white, // Cor do ícone
                    size: 20.0, // Tamanho do ícone
                  ),
                  const SizedBox(
                      width: 8.0), // Espaçamento entre o ícone e o texto
                  Text(
                    buttonText, // Texto do botão
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
