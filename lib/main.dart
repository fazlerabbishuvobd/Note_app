import 'package:flutter/material.dart';
import 'package:note_app/screens/splash_screen.dart';
import 'package:note_app/services/theme_services.dart';
import 'package:provider/provider.dart';


void main(){
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeServices(),
    builder: (context, child) {
      return const MyApp();
    })
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeServices(),)
      ],
      child: Consumer<ThemeServices>(
          builder: (context, value, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Note App',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(primary: Colors.amber,seedColor: Colors.amber),
                useMaterial3: true,
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                  brightness: Brightness.dark
              ),
              themeMode: value.themeMode,
              home: const SplashScreen(),
            );
          },
      ),
    );
  }
}
