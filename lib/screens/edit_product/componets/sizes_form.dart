import 'package:flutter/material.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/models/item_size.dart'; // Certifique-se de importar o modelo ItemSize

class SizesForm extends StatelessWidget {
  const SizesForm({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes, // Inicializa com os tamanhos do produto
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tamanhos disponíveis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    state.value!.add(ItemSize(
                      name: '',
                      price: 0,
                      stock: 0,
                    )); // Adiciona um tamanho vazio
                    state
                        .didChange(state.value); // Notifica a mudança no estado
                  },
                  child: const Text(
                    'Adicionar Tamanho',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            ...state.value!.map((size) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    // Campo para o nome do tamanho
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: size.name,
                        decoration: const InputDecoration(
                          labelText: 'Tamanho',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          size.name = value; // Atualiza o nome do tamanho
                          state.didChange(state.value); // Notifica a mudança
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Campo para o preço
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: size.price.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Preço',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          size.price =
                              num.tryParse(value) ?? 0; // Atualiza o preço
                          state.didChange(state.value); // Notifica a mudança
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Campo para o estoque
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: size.stock.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Estoque',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          size.stock =
                              int.tryParse(value) ?? 0; // Atualiza o estoque
                          state.didChange(state.value); // Notifica a mudança
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Botão para remover o tamanho
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        state.value!.remove(size); // Remove o tamanho
                        state.didChange(state.value); // Notifica a mudança
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
