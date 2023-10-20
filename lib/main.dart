import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unipay/Screens/Welcome/welcome_screen.dart';
import 'package:unipay/constants.dart';
import 'package:unipay/firebase_options.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart'; // Import this for PlatformException
import 'package:flutter/foundation.dart' show kIsWeb; // Import this to check if it's a web platform
import 'package:firebase_auth/firebase_auth.dart';

import 'Screens/Home/home_page.dart'; // Import Firebase Authentication

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    runApp(const MyApp());
  } else {
    final localAuth = LocalAuthentication();
    bool didAuthenticate = false;

    try {
      didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Authenticate to access the app',
      );
    } on PlatformException catch (e) {
      if (e.code == 'LAError.userCancel') {
        // Biometric authentication was canceled.
        print('Biometric authentication canceled');
      } else if (e.code == 'LAError.biometryNotAvailable') {
        // Biometric authentication is not available on this device.
        print('Biometric authentication not available');
      } else {
        // Handle other errors.
        print('Biometric authentication error: $e');
      }
    }

    if (didAuthenticate) {
      runApp(const MyApp());
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniPay',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: kPrimaryColor,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: kPrimaryLightColor,
          iconColor: kPrimaryColor,
          prefixIconColor: kPrimaryColor,
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: AuthenticateUser(), // Change this to check user authentication state
    );
  }
}

class AuthenticateUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is already authenticated, navigate to the homepage
      return HomePage();
    } else {
      // User is not authenticated, navigate to the welcome screen
      return WelcomeScreen();
    }
  }
}
