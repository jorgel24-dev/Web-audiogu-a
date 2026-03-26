import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioguia_web/router/go_router.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => NoticiasProvider()),
        // ChangeNotifierProvider(create: (_) => ConfigProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Audioguía Admin',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter, 
    );
  }
}