import 'package:flutter/material.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/screens/edit_product/components/images_form.dart';
import 'package:online_store/screens/edit_product/components/sizes_form.dart';

class EditProductScreens extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Product product;
  final bool editing;

  EditProductScreens({super.key, required Product? p})
      : editing = p != null,
        product = p?.clone() ??
            Product(
              id: '',
              name: '',
              description: '',
              images: [],
              sizes: [],
            );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          editing ? 'Editar Produto' : 'Criar Anúncio',
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
            FutureBuilder<num>(
              future: product.basePriceAsync,
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData
                      ? "R\$ ${snapshot.data!.toStringAsFixed(2)}"
                      : "Carregando...",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MinhasCores.rosa_3,
                  ),
                );
              },
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
            SizesForm(
              product: product,
              onSizesUpdated: _updateBasePrice,
            ),
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
      product.basePrice = pricesWithStock.reduce((a, b) => a < b ? a : b);
    }
  }

  Future<void> _saveProduct(BuildContext context) async {
    try {
      await product.saveToFirestore();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto salvo com sucesso!')),
      );
      // Redireciona para a tela do produto salvo
      Navigator.pushReplacementNamed(
        context,
        '/produtos', // Verifique se esta rota está definida no seu MaterialApp
        arguments: product,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar o produto: $e')),
      );
    }
  }
}
