import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/screens/edit_product/componets/image_source_sheet.dart';

class ImagesForm extends StatefulWidget {
  const ImagesForm({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  State<ImagesForm> createState() => _ImagesFormState();
}

class _ImagesFormState extends State<ImagesForm> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(widget.product.images),
      builder: (state) {
        final List<Widget> imageWidgets = state.value?.map<Widget>((image) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  if (image is String)
                    Image.network(image, fit: BoxFit.cover)
                  else if (image is File)
                    Image.file(image, fit: BoxFit.cover),

                  // Botão de remover imagem
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        state.value?.remove(image);
                        state.didChange(state.value);
                      },
                    ),
                  ),
                ],
              );
            }).toList() ??
            [];

        // Adicionando o botão de adicionar imagem ao final da lista
        imageWidgets.add(
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100], // Cor do fundo cinza
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add_a_photo,
                  size: 40,
                  color: MinhasCores.rosa_3,
                ),
                onPressed: () {
                  if (Platform.isAndroid) {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => ImageSourceSheet(),
                    );
                  } else {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (_) => ImageSourceSheet(),
                    );
                  }
                },
              ),
            ),
          ),
        );

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1.0, // Mantém a proporção da imagem
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 390,
                  viewportFraction: 1.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: imageWidgets,
              ),
            ),

            // Indicadores de página (bolinhas abaixo do carrossel)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.product.images.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => setState(() {
                    _currentIndex = entry.key; // Muda de página ao tocar
                  }),
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
            ),
          ],
        );
      },
    );
  }
}
