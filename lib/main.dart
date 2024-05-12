import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/user/user.model.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/views/home.views.dart';
import 'package:recdat/views/login.views.dart';
import 'package:recdat/views/register.views.dart';
import 'package:recdat/views/welcome.views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDUONtNp_DQHaV4l0Dp_IHBtkVSuTNaiLw",
          appId: "1:563746096021:android:1eccd6ef91897cd1302c9c",
          messagingSenderId: "",
          projectId: "recdat-app"));
  runApp(ChangeNotifierProvider(
    create: (_) => AuthProvider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navigator(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => const WelcomeView();
              break;
            case '/login':
              builder = (BuildContext context) => const LoginView();
              break;
            case '/register':
              builder = (BuildContext context) => RegisterView();
              break;
            case '/home':
              builder = (BuildContext context) => const HomeView();
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );
      },
    );
  }
}
