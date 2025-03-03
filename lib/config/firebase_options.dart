import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyCTH31X0LjZeVCVC2IYtTItX7LJAGZ6glU",
      appId: "1:1069204216516:android:c0abdcaee58efef70c8791",
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      projectId: "movieapp-e7dce",
    );
  }
}