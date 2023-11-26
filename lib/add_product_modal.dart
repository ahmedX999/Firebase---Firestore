import 'package:flutter/material.dart';

class AddProductModal extends StatelessWidget {
  final TextEditingController marqueController;
  final TextEditingController designationController;
  final TextEditingController categorieController;
  final TextEditingController prixController;
  final TextEditingController photoController;
  final TextEditingController quantiteController;
  final VoidCallback onAddProduct;

  AddProductModal({
    required this.marqueController,
    required this.designationController,
    required this.categorieController,
    required this.prixController,
    required this.photoController,
    required this.quantiteController,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ajouter un nouveau produit',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: marqueController,
              decoration: InputDecoration(labelText: 'Marque'),
            ),
            TextFormField(
              controller: designationController,
              decoration: InputDecoration(labelText: 'Désignation'),
            ),
            TextFormField(
              controller: categorieController,
              decoration: InputDecoration(labelText: 'Catégorie'),
            ),
            TextFormField(
              controller: prixController,
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: photoController,
              decoration: InputDecoration(labelText: 'URL de la photo'),
            ),
            TextFormField(
              controller: quantiteController,
              decoration: InputDecoration(labelText: 'Quantité'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                onAddProduct();
                Navigator.pop(context); // Close the modal
              },
              child: Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
