import 'package:flutter/material.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/screens/edit_product/componets/images_form.dart';
import 'package:online_store/screens/edit_product/componets/sizes_form.dart';

class EditProductScreens extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Product product;

  EditProductScreens({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Editar Produto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: MinhasCores.rosa_1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ImagesForm(product: product),
            TextFormField(
              initialValue: product.name,
              decoration: const InputDecoration(
                hintText: 'Nome do produto',
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 26,
                color: MinhasCores.rosa_3,
                fontWeight: FontWeight.bold,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório';
                }
                if (value.length < 6) {
                  return 'Nome muito curto';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                product.name = value ?? '';
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "A partir de",
                style: TextStyle(
                  fontSize: 17,
                  color: MinhasCores.rosa_1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "R\$ ${product.basePrice.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MinhasCores.rosa_3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                "Descrição",
                style: TextStyle(
                  fontSize: 16,
                  color: MinhasCores.rosa_1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              initialValue: product.description,
              decoration: const InputDecoration(
                hintText: 'Descrição do produto',
                border: InputBorder.none,
              ),
              maxLines: null,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              style: TextStyle(
                fontSize: 16,
                color: MinhasCores.rosa_3,
              ),
              onSaved: (value) {
                product.description = value ?? '';
              },
            ),
            SizesForm(product: product),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MinhasCores.rosa_3,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _updateBasePrice();
                  await _saveProduct(context);
                }
              },
              child: const Text(
                'Salvar',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateBasePrice() {
    final pricesWithStock =
        product.sizes.where((size) => size.stock > 0).map((size) => size.price);

    if (pricesWithStock.isNotEmpty) {
      // Defina manualmente a lógica de cálculo ou ajuste no modelo
      final basePrice = pricesWithStock.reduce((a, b) => a < b ? a : b);
      debugPrint('Preço base atualizado: R\$ $basePrice');
    } else {
      debugPrint('Nenhum tamanho com estoque disponível.');
    }
  }

  Future<void> _saveProduct(BuildContext context) async {
    try {
      await product.saveToFirestore();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto salvo com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar o produto: $e')),
      );
    }
  }
}
