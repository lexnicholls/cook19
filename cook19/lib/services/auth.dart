import 'package:cook19/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final instance = AuthService._();

  final fb = FirebaseAuth.instance;
  final db = DBService.instance;

  Future get currentUser async {
    return await fb.currentUser();
  }

  Future registerWithEmail(String email, String password, String name) async {
    try {
      await fb.createUserWithEmailAndPassword(email: email, password: password);
      final user = await instance.currentUser;
      await db.createUserDoc(email, name, user.uid);
    } catch (e) {
      rethrow;
    }
  }

  Future loginWithEmail(String email, String password) async {
    try {
      await fb.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future signOut() async {
    await fb.signOut();
  }
}
