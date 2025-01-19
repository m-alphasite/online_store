import 'dart:io'; // Necessário para trabalhar com arquivos locais
import 'package:carousel_slider/carousel_slider.dart'; // Carrossel de imagens
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Biblioteca para selecionar imagens
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/product.dart'; // Modelo do produto

class ImagesForm extends StatefulWidget {
  const ImagesForm({super.key, required this.product});

  final Product product;

  @override
  State<ImagesForm> createState() => _ImagesFormState();
}

class _ImagesFormState extends State<ImagesForm> {
  late List<dynamic> _images; // Lista de imagens
  int _currentIndex = 0; // Índice atual do carrossel

  @override
  void initState() {
    super.initState();
    _images = widget.product.images ?? []; // Inicializa a lista de imagens
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path)); // Adiciona a imagem selecionada
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Escolher da Galeria'),
                onTap: () {
                  Navigator.of(context).pop(); // Fecha o modal
                  _pickImage(ImageSource.gallery); // Seleciona da galeria
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tirar uma Foto'),
                onTap: () {
                  Navigator.of(context).pop(); // Fecha o modal
                  _pickImage(ImageSource.camera); // Abre a câmera
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(dynamic image) {
    setState(() {
      _images.remove(image); // Remove a imagem selecionada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carrossel de imagens
        AspectRatio(
          aspectRatio: 1.0, // Mantém a proporção quadrada
          child: CarouselSlider(
            options: CarouselOptions(
              height: 390,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              autoPlay: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index; // Atualiza o índice atual
                });
              },
            ),
            items: [
              ..._images.map((image) {
                return Stack(
                  children: [
                    if (image is String)
                      Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    else if (image is File)
                      Image.file(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 24,
                        ),
                        onPressed: () => _removeImage(image),
                      ),
                    ),
                  ],
                );
              }).toList(),
              // Botão de adicionar imagem com efeito de toque
              InkWell(
                onTap: _showImageSourceActionSheet,
                borderRadius: BorderRadius.circular(100),
                splashColor: MinhasCores.rosa_2.withOpacity(0.5),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_a_photo,
                    size: 40,
                    color: MinhasCores.rosa_3,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        // Indicadores do carrossel com círculo adicional
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ..._images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = entry.key;
                  });
                },
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? MinhasCores.rosa_2
                        : MinhasCores.rosa_3,
                  ),
                ),
              );
            }).toList(),
            // Círculo adicional para o botão de adicionar imagem
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex =
                      _images.length; // Seleciona o botão de adicionar
                });
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == _images.length
                      ? MinhasCores.rosa_2
                      : MinhasCores.rosa_3,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
