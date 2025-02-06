import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/product.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagesForm extends StatefulWidget {
  final Product product;

  const ImagesForm({super.key, required this.product});

  @override
  State<ImagesForm> createState() => _ImagesFormState();
}

class _ImagesFormState extends State<ImagesForm> {
  int _currentIndex = 0;

  Future<bool> _checkPermissions() async {
    // Para Android 13+ (API 33), usar READ_MEDIA_IMAGES ao invés de READ_EXTERNAL_STORAGE
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isDenied &&
          await Permission.photos.request().isDenied &&
          await Permission.camera.request().isDenied) {
        return false;
      }
    } else if (Platform.isIOS) {
      // Para iOS, solicitar acesso à câmera e à galeria
      if (await Permission.photos.request().isDenied ||
          await Permission.camera.request().isDenied) {
        return false;
      }
    }
    return true;
  }

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
        maxWidth: 800, // Reduz tamanho da imagem
        maxHeight: 800,
        imageQuality: 70, // Reduz qualidade para economizar memória
      );

      if (pickedFile != null) {
        File selectedFile = File(pickedFile.path);

        // Verifica se o arquivo existe antes de prosseguir
        if (!await selectedFile.exists()) {
          debugPrint('Arquivo não encontrado!');
          return;
        }

        final croppedFile = await _cropImage(selectedFile);
        if (croppedFile != null) {
          final newList = List<String>.from(state.value ?? []);
          newList.add(croppedFile.path);
          state.didChange(newList);
        }
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
    }
  }

  void _showImageSourceActionSheet(FormFieldState<List<dynamic>> state) async {
    bool hasPermission = await _checkPermissions();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Permissão negada! Vá para as configurações do dispositivo para ativar.")),
      );
      return;
    }

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
    final newList = List<String>.from(state.value ?? []);
    newList.remove(image);
    state.didChange(newList);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(widget.product.images),
      validator: (images) {
        if (images == null || images.isEmpty) {
          return 'Selecione pelo menos uma imagem';
        }
        return null;
      },
      builder: (state) {
        final images = state.value ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: CarouselSlider.builder(
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
                itemCount: images.length + 1,
                itemBuilder: (context, index, realIndex) {
                  if (index == images.length) {
                    return InkWell(
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
                    );
                  }

                  final image = images[index];
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
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            );
                          },
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
                },
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
