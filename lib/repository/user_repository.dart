import 'package:stok_app/locator.dart';
import 'package:stok_app/models/kullanici.dart';
import 'package:stok_app/services/firebase_auth_service.dart';
import 'package:stok_app/services/firestore_db_service.dart';

class UserRepository {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirebaseDbService _firebaseDbService = locator<FirebaseDbService>();
  //FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  Future<Kullanici?> currentUser() async {
    Kullanici? _kullanici = await _firebaseAuthService.currentUser();
    if (_kullanici != null) {
      return await _firebaseDbService.readUser(_kullanici.userID!);
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  Future<Kullanici?> signInWithEmailAndPassword(String uyeNo, String sifre) async {
    Kullanici? _kullanici =
        await _firebaseAuthService.signInWithEmailAndPassword(uyeNo, sifre);

    if (_kullanici != null) {
      return await _firebaseDbService.readUser(_kullanici.userID!);
    } else {
      return null;
    }
  }

  Future<Kullanici?> createUserWithEmailAndPassword(
      String uyeNo, String sifre, String name) async {
    Kullanici? _kullanici =
        await _firebaseAuthService.createUserWithEmailAndPassword(uyeNo, sifre);
    if (_kullanici != null) {
      _kullanici.name = name;
      _kullanici.uyeNo = uyeNo;
      return await _firebaseDbService.saveUser(_kullanici);
    } else {
      return null;
    }
  }
}
