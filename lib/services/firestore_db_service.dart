import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stok_app/models/kullanici.dart';
import 'package:stok_app/models/urun_model.dart';
import 'package:stok_app/services/db_base.dart';

class FirebaseDbService implements DbBase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Kullanici?> readUser(String userID) async {
    DocumentSnapshot _okunanUser = await _firestore.collection("users").doc(userID).get();

    if (_okunanUser.data() != null) {
      return Kullanici.fromMap(_okunanUser.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<Kullanici?> saveUser(Kullanici kullanici) async {
    var sonuc = await _firestore.collection("users").doc(kullanici.userID).get();
    if (sonuc.data() == null) {
      await _firestore.collection("users").doc(kullanici.userID).set(kullanici.toMap());
      DocumentSnapshot documentSnapshot =
          await _firestore.collection("users").doc(kullanici.userID).get();
      if (documentSnapshot.data()!.isNotEmpty) {
        return Kullanici.fromMap(documentSnapshot.data()!);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<List<Urun>> getUrunler(String? tip1, String? tip2) async {
    List<Urun> urunler = [];
    if (tip1 != null) {
      if (tip2 == null) {
        QuerySnapshot sonuc =
            await _firestore.collection("products").where('tip1', isEqualTo: tip1).get();

        for (QueryDocumentSnapshot tekUrun in sonuc.docs) {
          urunler.add(Urun.fromMap(tekUrun.data()!));
        }
      } else {
        QuerySnapshot sonuc = await _firestore
            .collection("products")
            .where('tip1', isEqualTo: tip1)
            .where('tip2', isEqualTo: tip2)
            .get();

        for (QueryDocumentSnapshot tekUrun in sonuc.docs) {
          urunler.add(Urun.fromMap(tekUrun.data()!));
        }
      }
    }

    return urunler;
  }
}
