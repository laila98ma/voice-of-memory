import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDuedPKGiaZfwELjanb3ieyrY1OIrutn6o",
            authDomain: "voiceof-memory-pyijw1.firebaseapp.com",
            projectId: "voiceof-memory-pyijw1",
            storageBucket: "voiceof-memory-pyijw1.firebasestorage.app",
            messagingSenderId: "852403981335",
            appId: "1:852403981335:web:3e8447fd2c84cdddad2052"));
  } else {
    await Firebase.initializeApp();
  }
}
