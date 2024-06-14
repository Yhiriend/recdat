import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recdat/modules/institute/institute.model.dart';
import 'package:recdat/modules/user/model/user.model.dart' as user_model;
import 'package:recdat/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  user_model.UserModel? _user;
  bool _isSignedIn = false;
  String _verificationId = "";
  bool _isLoading = false;
  String? _uid;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  user_model.UserModel? get user => _user;
  bool get isSignedIn => _isSignedIn;
  String get verificationId => _verificationId;
  bool get isLoading => _isLoading;
  String get uid => _uid ?? "";

  AuthProvider() {
    checkSign();
  }

  void setUser(user_model.UserModel user) {
    _user = user;
    notifyListeners();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await saveUserDataToSP();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            _verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString(), SnackBarType.error);
    }
  }

  void verifyOtp(
      {required BuildContext context,
      required String verificationId,
      required String userOtp,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user =
          (await _firebaseAuth.signInWithCredential(phoneAuthCredential)).user;
      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString(), SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      //print("USER EXISTS");
      return true;
    } else {
      //print("NEW USER");
      return false;
    }
  }

  void saveUserDataToFirebase(
      {required BuildContext context,
      required user_model.UserModel userModel,
      required Function onSuccess}) async {
    showSnackBar(context, "Creando usuario", SnackBarType.none);
    _isLoading = true;
    notifyListeners();
    try {
      userModel.uid = _uid;
      _user = userModel;
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        showSnackBar(context, "Usuario creado", SnackBarType.success);
        onSuccess();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString(), SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void createInstitute(
      BuildContext context, String instituteName, Function onSuccess) async {
    _isLoading = true;
    showSnackBar(context, "Creando instituto", SnackBarType.none);
    try {
      InstituteModel instituteModel = InstituteModel(
          uid: _uid,
          name: instituteName,
          courses: [],
          createdAt: RecdatDateUtils.currentDate());
      await _firebaseFirestore
          .collection("institutes")
          .doc(_uid)
          .set(instituteModel.toMap())
          .then((value) {
        showSnackBar(context, "Instituto creado", SnackBarType.success);
        onSuccess();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString(), SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future saveUserDataToSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("user_model", jsonEncode(user?.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString("user_model") ?? "";
    if (data.isEmpty) return;
    final decodedData = jsonDecode(data);
    print("SHARED PREFERENCES $decodedData");
    _user = user_model.UserModel.fromMap(jsonDecode(data));
    print("USER DATA $_user");
    _uid = _user!.uid ?? "";
    print("USER UID $_uid");
    if (_uid != "") {
      print("INSIDE CONDITION");
      await setSignIn();
    }
    notifyListeners();
  }

  Future<bool> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final CollectionReference usersCollection =
          _firebaseFirestore.collection("users");

      final QuerySnapshot userSnapshot =
          await usersCollection.where('email', isEqualTo: email).get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;

        final userData = userDoc.data() as Map<String, dynamic>;

        if (userData['password'] == password) {
          final userModel = user_model.UserModel.fromMap(userData);

          setUser(userModel);

          await setSignIn();

          return true;
        }
        return false;
      }

      // Si no se encuentra el usuario o la contraseña no coincide, mostrar un mensaje de error
      throw FirebaseAuthException(
        code: 'invalid-credentials',
        message: 'Credenciales inválidas',
      );
    } catch (e) {
      String errorMessage = 'Ocurrió un error. Inténtalo de nuevo.';
      if (e is FirebaseAuthException && e.code == 'invalid-credentials') {
        errorMessage = 'Credenciales inválidas';
      }
      // Mostrar un mensaje de error en caso de cualquier excepción
      showSnackBar(context, errorMessage, SnackBarType.error);
      return false;
    } finally {
      // Establecer isLoading en false y notificar a los oyentes
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.remove("user_model");
      await sharedPreferences.setBool("is_signedin", false);
      _user = null;
      _isSignedIn = false;
      _uid = null;
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (e) {
      showSnackBar(context, "Error al cerrar sesión: $e", SnackBarType.error);
    }
  }

  Future<void> syncUserDataByUid(BuildContext context, String uid) async {
    try {
      DocumentSnapshot doc =
          await _firebaseFirestore.collection("users").doc(uid).get();
      if (doc.exists) {
        _user =
            user_model.UserModel.fromMap(doc.data() as Map<String, dynamic>);
        await saveUserDataToSP();
        showSnackBar(context, "Usuario sincronizado", SnackBarType.success);
        notifyListeners();
      }
    } catch (e) {
      showSnackBar(
          context, "Ups! no fue posible sincronizar", SnackBarType.error);
    }
  }
}
