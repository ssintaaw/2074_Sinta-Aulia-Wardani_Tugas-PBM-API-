import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/add_product_page.dart';
import 'screens/submit_page.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'token');

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => PrelovedApp(
        initialRoute: token != null ? '/home' : '/login',
      ),
    ),
  );
}

class PrelovedApp extends StatelessWidget {
  final String initialRoute;
  
  const PrelovedApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrelovedArea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF6E2137),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6E2137),
          primary: const Color(0xFF6E2137),
          secondary: const Color(0xFF9B4B68),
          surface: const Color(0xFFFFFDFD),
          onSurface: const Color(0xFF2B2B2B),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7EEF2),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF6E2137),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      initialRoute: initialRoute,
      builder: (context, child) {
        
        return MobileFrame(child: child!);
      },
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/add': (context) => const AddProductPage(),
        '/submit': (context) => const SubmitPage(),
      },
    );
  }
}

class MobileFrame extends StatelessWidget {
  final Widget child;
  const MobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 500) {
          return Container(
            color: const Color(0xFFE0E0E0), 
            child: Center(
              child: Container(
                width: 375,
                height: 812,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.black, width: 8), 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
          );
        }
        return child;
      },
    );
  }
}
