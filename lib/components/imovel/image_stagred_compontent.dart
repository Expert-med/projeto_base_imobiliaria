import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageGridPage extends StatelessWidget {
  final List<String> imageUrls;

  const ImageGridPage({Key? key, required this.imageUrls}) : super(key: key);
@override
  Widget build(BuildContext context) {
    return Center(
        child: MasonryGridView.builder(
          itemCount: imageUrls.length,
          gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, // Ajustar a largura da coluna
            
          ),
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
      
    );
  }
}

