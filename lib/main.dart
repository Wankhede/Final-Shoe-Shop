import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAHJdrFT7ykv4On9zniDAzmhU2UPEQWMvo",
      authDomain: "shoehub-dc237.firebaseapp.com",
      projectId: "shoehub-dc237",
      storageBucket: "shoehub-dc237.firebasestorage.app",
      messagingSenderId: "1071354385129",
      appId: "1:1071354385129:web:d1b9998a1b264a4c8ad678",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Shoe Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: AppTheme.colorScheme,
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppTheme.appBarTheme,
          elevatedButtonTheme: AppTheme.elevatedButtonTheme,
          inputDecorationTheme: AppTheme.inputDecorationTheme,
          // cardTheme: AppTheme.cardTheme,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
