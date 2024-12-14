import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:online_store/models/section.dart';
import 'package:online_store/screens/home/components/section_header.dart';

class SectionStaggered extends StatelessWidget {
  final Section section;

  const SectionStaggered(this.section, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(section),
          const SizedBox(height: 4), // Add some spacing
          StaggeredGridView.countBuilder(
            // Use StaggeredGridView.countBuilder
            padding: EdgeInsets.zero, // Removes default padding
            crossAxisCount: 4,
            itemCount: section.items.length,
            itemBuilder: (BuildContext context, int index) => Image.network(
              section.items[index].image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Improved error handling
                return Container(
                  color: Colors.grey,
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                // Loading indicator
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.count(2, index.isEven ? 2 : 1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }
}
