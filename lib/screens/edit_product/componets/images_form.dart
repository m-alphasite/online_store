import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/product.dart';

class ImagesForm extends StatefulWidget {
  final Product product;

  const ImagesForm({super.key, required this.product});

  @override
  State<ImagesForm> createState() => _ImagesFormState();
}

class _ImagesFormState extends State<ImagesForm> {
  int _currentIndex = 0;

  Future<File?> _cropImage(File imageFile) async {
    try {
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
    } catch (e) {
      debugPrint('Erro ao recortar imagem: $e');
      return null;
    }
  }

  Future<void> _pickImage(
      ImageSource source, FormFieldState<List<dynamic>> state) async {
    try {
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
          setState(() {
            state.value!.add(croppedFile.path);
          });
          state.didChange(state.value);
        }
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
    }
  }

  void _showImageSourceActionSheet(FormFieldState<List<dynamic>> state) {
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
                  _pickImage(ImageSource.gallery, state);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar uma Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera, state);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(String image, FormFieldState<List<dynamic>> state) {
    setState(() {
      state.value!.remove(image);
    });
    state.didChange(state.value);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(widget.product.images),
      validator: (images) {
        if (images!.isEmpty) {
          return 'Selecione pelo menos uma imagem';
        } else {
          return null;
        }
      },
      builder: (state) {
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
                    setState(() {
                      _currentIndex = index;
                    });
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
                            onPressed: () => _removeImage(image, state),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  InkWell(
                    onTap: () => _showImageSourceActionSheet(state),
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
