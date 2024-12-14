import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  List<Section> sections = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen((snapshot) {
      sections.clear(); // Limpa a lista antes de adicionar novas seções
      for (final QueryDocumentSnapshot document in snapshot.docs) {
        final section = Section.fromDocument(document);
        sections.add(section);
        // Imprime as URLs das imagens no terminal para depuração
        for (final item in section.items) {
          print('Loaded image URL: ${item.image}');
        }
      }
      notifyListeners();
    });
  }
}
