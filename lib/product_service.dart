import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addProduct({
    required String marque,
    required String designation,
    required String categorie,
    required double prix,
    required String photo,
    required int quantite,
  }) async {
    try {
      await _db.collection('produits').add({
        'marque': marque,
        'designation': designation,
        'categorie': categorie,
        'prix': prix,
        'photo': photo,
        'quantite': quantite,
      });
    } catch (e) {
      print('Error adding product to Firestore: $e');
      rethrow;
    }
  }
}
