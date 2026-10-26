import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuth get auth => _auth;
  User? get currentUser => Firebase.apps.isNotEmpty ? _auth.currentUser : null;
  Stream<User?> get authStateChanges => Firebase.apps.isNotEmpty
      ? _auth.authStateChanges()
      : const Stream.empty();

  /// 1. Masuk dengan Email & Password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// 2. Daftar Akun Baru dengan Email, Password & Nama
  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null && name.trim().isNotEmpty) {
      await credential.user!.updateDisplayName(name.trim());
      await credential.user!.reload();
    }

    return credential;
  }

  /// 3. Masuk dengan Akun Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Pastikan sesi akun Google sebelumnya direset agar modal pemilih akun muncul
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint('Google pre-signout note: $e');
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User membatalkan proses sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      debugPrint('Error signInWithGoogle: $e');
      rethrow;
    }
  }

  /// 4. Kirim Email Reset Password
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// 5. Keluar / Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  /// Menerjemahkan kode error Firebase Auth ke pesan bahasa Indonesia yang ramah
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Format alamat email tidak valid.';
        case 'user-disabled':
          return 'Akun dengan email ini telah dinonaktifkan.';
        case 'user-not-found':
          return 'Akun dengan email ini belum terdaftar.';
        case 'wrong-password':
          return 'Kata sandi yang Anda masukkan salah.';
        case 'invalid-credential':
          return 'Email atau kata sandi tidak cocok. Silakan periksa kembali.';
        case 'email-already-in-use':
          return 'Email ini sudah terdaftar. Silakan masuk ke akun Anda.';
        case 'operation-not-allowed':
          return 'Metode login ini belum diaktifkan di Firebase Console.';
        case 'weak-password':
          return 'Kata sandi terlalu pendek/lemah. Gunakan minimal 6 karakter.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan gagal. Silakan coba sesaat lagi.';
        case 'network-request-failed':
          return 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
        default:
          return error.message ?? 'Terjadi kesalahan autentikasi (${error.code}).';
      }
    }
    return error?.toString() ?? 'Terjadi kendala yang tidak terduga.';
  }
}
