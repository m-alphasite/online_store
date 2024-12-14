import 'package:flutter/material.dart';
import 'package:online_store/models/section.dart';

class SectionHeader extends StatelessWidget {
  final Section section;

  const SectionHeader(this.section, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        section.name,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
      ),
    ); // Exibe o título da seção();
  }
}
