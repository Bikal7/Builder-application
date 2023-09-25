import 'package:builder/Add%20Info/professions.dart';
import 'package:builder/bottomNav.dart';
import 'package:builder/login.dart';
import 'package:builder/register.dart';
import 'package:builder/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/loginbloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/bottomNav':(context) => const bottomNav(),
          '/login': (context) => const Login(),
          '/register': (context) => const RegisterForm(),
          '/': (context) => const SplashScreen(),
          '/h': (context) => const ProfessionForm(),
          // Add other named routes as needed
        },
      ),
    );
  }
}
