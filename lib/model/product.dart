import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'products';

  void uploadProduct(
  {
    required String productName,
    required String productCategory,
    required String productBrand,
    required List sizes,
    required List images,
    required int productQuantity,
    required double productPrice,
}) {
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection(ref).doc(productId).set(
        {
          'name' : productName,
          'id' : productId,
          'category' : productCategory,
          'brand' : productBrand,
          'name' : productName,
          'name' : productName,
          'name' : productName,
          'name' : productName,
        });
  }

 /* Future<List<DocumentSnapshot>> getProduct() =>
      _firestore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) => _firestore.collection(ref).where('product',isEqualTo: suggestion).get().then((snapshot)
  {
    return snapshot.docs;
  });*/
}
