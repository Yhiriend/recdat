import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/views/home.views.dart';
import 'package:recdat/views/login.views.dart';
import 'package:recdat/views/register.views.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
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
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => const LoginView();
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
