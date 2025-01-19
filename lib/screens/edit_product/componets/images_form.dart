import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/product.dart';

class ImagesForm extends StatelessWidget {
  final Product product;

  const ImagesForm({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      // FormField para controlar o estado das imagens
      initialValue: List.from(product.images),
      validator: (images) {
        if (images!.isEmpty) {
          return 'Selecione pelo menos uma imagem';
        } else {
          return null;
        }
      }, // Inicia com as imagens do produto
      builder: (state) {
        int _currentIndex = 0; // Controla o índice do carrossel

        Future<File?> _cropImage(File imageFile) async {
          final croppedFile = await ImageCropper().cropImage(
            sourcePath: imageFile.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Editar Imagem',
                toolbarColor: MinhasCores.rosa_1,
                toolbarWidgetColor: Colors.white,
                backgroundColor: Colors.black,
                showCropGrid: true,
                lockAspectRatio: false,
              ),
              IOSUiSettings(
                title: 'Editar Imagem',
                doneButtonTitle: 'Salvar',
                cancelButtonTitle: 'Cancelar',
                aspectRatioLockEnabled: false,
              ),
            ],
          );
          return croppedFile != null ? File(croppedFile.path) : null;
        }

        Future<void> _pickImage(ImageSource source) async {
          final picker = ImagePicker();
          final pickedFile = await picker.pickImage(
            source: source,
            maxWidth: 800,
            maxHeight: 800,
            imageQuality: 80,
          );

          if (pickedFile != null) {
            final croppedFile = await _cropImage(File(pickedFile.path));
            if (croppedFile != null) {
              state.value!.add(croppedFile.path); // Adiciona imagem editada
              state.didChange(state.value); // Atualiza o estado
            }
          } else {
            print("Nenhuma imagem selecionada ou erro na captura.");
          }
        }

        void _showImageSourceActionSheet() {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Escolher da Galeria'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Tirar uma Foto'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }

        void _removeImage(String image) {
          state.value!.remove(image); // Remove a imagem da lista
          state.didChange(state.value); // Atualiza o estado
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    _currentIndex = index; // Atualiza o índice localmente
                  },
                ),
                items: [
                  ...state.value!.map((image) {
                    return Stack(
                      children: [
                        if (Uri.tryParse(image)?.isAbsolute ?? false)
                          Image.network(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        else
                          Image.file(
                            File(image),
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
                            offset: const Offset(0, 2),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: state.value!.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    // Lógica ao clicar no indicador
                  },
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: entry.key == _currentIndex
                          ? MinhasCores.rosa_2
                          : MinhasCores.rosa_3,
                    ),
                  ),
                );
              }).toList(),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
