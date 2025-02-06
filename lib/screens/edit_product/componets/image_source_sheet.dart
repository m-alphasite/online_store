import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File?) onImageSelected;

  ImageSourceSheet({super.key, required this.onImageSelected});

  final ImagePicker picker = ImagePicker();

  Future<void> _getImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? file = await picker.pickImage(source: source);
      if (file != null) {
        debugPrint("Imagem selecionada: ${file.path}"); // 🛠 Log para depuração
        onImageSelected(File(file.path)); // Retorna a imagem selecionada
      } else {
        debugPrint("Seleção de imagem cancelada.");
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
    }
    Navigator.of(context).pop(); // Fecha o modal
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? BottomSheet(
            onClosing: () {},
            backgroundColor: Colors.transparent,
            builder: (_) => Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Câmera'),
                  onTap: () => _getImage(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galeria'),
                  onTap: () => _getImage(context, ImageSource.gallery),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.grey[100],
            child: CupertinoActionSheet(
              title: const Text('Selecionar foto para o produto'),
              message: const Text('Escolha a origem da foto'),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: () => _getImage(context, ImageSource.camera),
                  child: const Text('Câmera'),
                ),
                CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: () => _getImage(context, ImageSource.gallery),
                  child: const Text('Galeria'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child:
                    const Text('Cancelar', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          );
  }
}
