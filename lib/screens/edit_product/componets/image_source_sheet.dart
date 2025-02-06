import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({super.key});

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
                  onTap: () {
                    Navigator.of(context).pop('camera');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galeria'),
                  onTap: () {
                    Navigator.of(context).pop('gallery');
                  },
                ),
              ],
            ),
          )
        : CupertinoActionSheet(
            title: const Text('Selecionar foto para o produto'),
            message: const Text('Escolha a origem da foto'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop('camera');
                },
                child: const Text('Câmera'),
              ),
              CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop('Galeria');
                },
                child: const Text('Galeria'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          );
  }
}
