import 'package:flutter/material.dart';
import 'package:my_profile_ketan/pages/splash/splash_page.dart';
import 'package:my_profile_ketan/providers/user_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Required for async calls in `main`
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
