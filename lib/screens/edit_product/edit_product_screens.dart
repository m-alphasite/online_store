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
            // Uso do ImagesForm
            ImagesForm(
              product: product,
            ),
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
              validator: (value) => value!.isEmpty
                  ? 'Campo obrigatório'
                  : null, // Uso do ImagesForm
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "A partir de", // Texto adicional
                style: TextStyle(
                  fontSize: 17,
                  color: MinhasCores.rosa_1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "R\$ ${product.basePrice.toStringAsFixed(2)}", // Exibe o preço do produto
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MinhasCores.rosa_3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                "Descrição", // Cabeçalho da descrição do produto
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
            ),
            SizesForm(product: product),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print('Válido!');
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
