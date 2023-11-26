import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'produit.dart';

class ListeProduits extends StatefulWidget {
  const ListeProduits({Key? key}) : super(key: key);

  @override
  State<ListeProduits> createState() => _ListeProduitsState();
}

class _ListeProduitsState extends State<ListeProduits> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController marqueController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController categorieController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController photoController = TextEditingController();
  TextEditingController quantiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des produits'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection("produits").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Une erreur est survenue'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Produit> produits = snapshot.data!.docs.map((doc) {
            return Produit.fromFirestore(doc);
          }).toList();

          if (produits.isEmpty) {
            return const Center(child: Text('Aucun produit disponible'));
          }

          return ListView.separated(
            itemCount: produits.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (context, index) => ProduitItem(
              produit: produits[index],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductModal(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddProductModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                    _addProductToFirestore();
                    Navigator.pop(context); // Close the modal
                  },
                  child: Text('Ajouter'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addProductToFirestore() async {
    try {
      await db.collection('produits').add({
        'marque': marqueController.text,
        'designation': designationController.text,
        'categorie': categorieController.text,
        'prix': double.parse(prixController.text),
        'photo': photoController.text,
        'quantite': int.parse(quantiteController.text),
      });

      marqueController.clear();
      designationController.clear();
      categorieController.clear();
      prixController.clear();
      photoController.clear();
      quantiteController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produit ajouté avec succès'),
        ),
      );
    } catch (e) {
      print('Error adding product to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'ajout du produit: $e'),
        ),
      );
    }
  }
}

class ProduitItem extends StatelessWidget {
  ProduitItem({Key? key, required this.produit}) : super(key: key);

  final Produit produit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(16.0),
      title: Text(
        produit.designation,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(produit.marque),
          SizedBox(height: 8.0),
          Text(
            '${produit.prix} MAD',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          SizedBox(height: 8.0),
          Text(
            'Quantité : ${produit.quantite}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Categorie : ${produit.categorie}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          produit.photo,
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
