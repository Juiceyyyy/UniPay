import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unipay/Screens/Welcome/welcome_screen.dart';
import 'package:unipay/components/constants.dart';
import 'package:unipay/components/firebase_options.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart'; // Import this for PlatformException
import 'Screens/Home/admin_home.dart';
import 'Screens/Home/user_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Global variable to store the user's role
bool isAdmin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final localAuth = LocalAuthentication();

  // Check if biometric authentication is available
  List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();

  // If biometric authentication is available and user has set it up, authenticate
  if (availableBiometrics.isNotEmpty) {
    bool didAuthenticate = false;

    try {
      didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Authenticate to access the app',
      );
    } on PlatformException catch (e) {
      if (e.code == 'LAError.userCancel') {
        print('Biometric authentication canceled');
      } else if (e.code == 'LAError.biometryNotAvailable') {
        print('Biometric authentication not available');
      } else {
        print('Biometric authentication error: $e');
      }
    }

    // Proceed with the app if authentication was successful
    if (didAuthenticate) {
      runApp(MyApp());
    }
  } else {
    // If biometric authentication is not available or not set up, proceed with the app
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniPay',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: color12,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: color15,
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.active) {
                    bool isAdmin = userSnapshot.data?['Admin'] ?? false;
                    return isAdmin ? AdminPage() : HomePage();
                  } else {
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            } else {
              return WelcomeScreen();
            }
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
