import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'image_source_sheet.dart';

class ImagesForm extends StatefulWidget {
  const ImagesForm({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  State<ImagesForm> createState() => _ImagesFormState();
}

class _ImagesFormState extends State<ImagesForm> {
  int _currentIndex = 0;

  void _addImage(File? image) {
    if (image != null) {
      debugPrint("Imagem adicionada à lista: ${image.path}");

      setState(() {
        widget.product.images.add(image.path); // Adiciona a imagem à lista
      });

      debugPrint("Lista de imagens atualizada: ${widget.product.images}");
    } else {
      debugPrint("Nenhuma imagem foi adicionada.");
    }
  }

  void _showImageSourceSheet(FormFieldState<List<dynamic>> state) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ImageSourceSheet(
        onImageSelected: (File? image) {
          if (image != null) {
            setState(() {
              state.value?.add(image.path);
              state.didChange(state.value); // Atualiza o FormField
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(widget.product.images),
      builder: (state) {
        final List<Widget> imageWidgets = state.value?.map<Widget>((image) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  if (image is String && image.startsWith('http'))
                    Image.network(image,
                        fit: BoxFit.cover) // Imagem da Internet
                  else if (image is String)
                    Image.file(File(image), fit: BoxFit.cover), // Imagem local

                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          state.value?.remove(image);
                          state.didChange(state.value);
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList() ??
            [];

        imageWidgets.add(
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: IconButton(
                icon: const Icon(Icons.add_a_photo,
                    size: 40, color: MinhasCores.rosa_3),
                onPressed: () => _showImageSourceSheet(state),
              ),
            ),
          ),
        );

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: state.value!.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => setState(() {
                    _currentIndex = entry.key;
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
