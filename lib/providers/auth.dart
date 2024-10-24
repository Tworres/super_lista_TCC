import 'package:firebase_auth/firebase_auth.dart';

enum AuthState { loading, signed, notSigned }

class Auth {
  UserCredential? _userCredential;
  User? _user;
  String? _id;
  static AuthState state = AuthState.notSigned;
  static Auth? _instance;

  Auth._();

  static Auth _getInstance(){
    _instance ??= Auth._();

    return _instance!;
  }

  static String id() {
    Auth auth = _getInstance();

    if (Auth.state == AuthState.loading) {
      throw Exception('Auth está carregando');
    }
    
    if (Auth.state == AuthState.notSigned) {
      throw Exception('Usuário não está logado');
    }
    
    if(auth._id == null){
      throw Exception('Não foi possível capturar o ID do usuário');
    }

    return auth._id!;
  
  }

  static Future<User?> user() async {
    Auth auth = await _getInstance();

    if (Auth.state == AuthState.loading) {
      throw Exception('Auth está carregando');
    } else if (Auth.state == AuthState.notSigned) {
      return null;
    } else if (Auth.state == AuthState.signed) {
      return auth._user;
    }

    return null;
  }

  static Future ensureInitialized() async {
    Auth._instance ??= Auth._();

    if (Auth.state == AuthState.signed) return;

    Auth.state = AuthState.loading;

    try {
      _instance!._userCredential = await FirebaseAuth.instance.signInAnonymously();
      _instance!._user = _instance!._userCredential?.user;
      _instance!._id = _instance!._user?.uid;

      Auth.state = AuthState.signed;

      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }
}
