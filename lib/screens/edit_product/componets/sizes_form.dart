import 'package:flutter/material.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/models/item_size.dart';

class SizesForm extends StatelessWidget {
  const SizesForm({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
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
                    final newSize = ItemSize(name: '', price: 0, stock: 0);
                    final updatedList = [...?state.value, newSize];
                    state.didChange(updatedList);
                  },
                  child: const Text(
                    'Adicionar Tamanho',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            ...?state.value?.map((size) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue: size.name,
                            decoration: const InputDecoration(
                              labelText: 'Tamanho',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              final index = state.value!.indexOf(size);
                              state.value![index].name = value.trim();
                              state.didChange(state.value);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: size.price.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Preço',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) {
                              final index = state.value!.indexOf(size);
                              state.value![index].price =
                                  num.tryParse(value) ?? 0;
                              state.didChange(state.value);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
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
                              final index = state.value!.indexOf(size);
                              state.value![index].stock =
                                  int.tryParse(value) ?? 0;
                              state.didChange(state.value);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            state.value!.remove(size);
                            state.didChange(state.value);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList() ??
                [],
          ],
        );
      },
    );
  }
}
