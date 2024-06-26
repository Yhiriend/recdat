import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/course/providers/course.provider.dart';
import 'package:recdat/modules/course/views/courses.view.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/modules/user/views/create_teacher.view.dart';
import 'package:recdat/modules/user/views/schedule_assigment.view.dart';
import 'package:recdat/modules/user/views/teacher.view.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/utils/routes.dart';
import 'package:recdat/views/home.view.dart';
import 'package:recdat/views/login.view.dart';
import 'package:recdat/views/register.view.dart';
import 'package:recdat/views/welcome.view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyCUj_GZeUXG9DENa-OUrT_FI-2om8gNsHQ",
    appId: "1:1079332323494:android:0617d92da12fa13e667467",
    messagingSenderId: "",
    projectId: "recdat-device",
    storageBucket: "recdat-device.appspot.com",
  ));
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //   apiKey: "AIzaSyDUONtNp_DQHaV4l0Dp_IHBtkVSuTNaiLw",
  //   appId: "1:563746096021:android:1eccd6ef91897cd1302c9c",
  //   messagingSenderId: "",
  //   projectId: "recdat-app",
  //   storageBucket: "recdat-app.appspot.com",
  // ));
  await FirebaseAppCheck.instance.activate(
    webProvider:
        ReCaptchaV3Provider("6Levq_8pAAAAAKTk7RjB6qpIdCDCcaNiHqIJTQ-r"),
    androidProvider: AndroidProvider.debug,
  );
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Navigator(
          initialRoute: '/',
          onGenerateRoute: (settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case '/':
                builder = (BuildContext context) => const WelcomeView();
                break;
              case RecdatRoutes.login:
                builder = (BuildContext context) => const LoginView();
                break;
              case RecdatRoutes.register:
                builder = (BuildContext context) => const RegisterView();
                break;
              case RecdatRoutes.home:
                builder = (BuildContext context) => const HomeView();
                break;
              case RecdatRoutes.createTeacher:
                builder = (BuildContext context) => const CreateTeacherView();
                break;
              case RecdatRoutes.courses:
                builder = (BuildContext context) => const CoursesView();
                break;
              case RecdatRoutes.teachers:
                builder = (BuildContext context) => const TeachersView();
                break;
              case RecdatRoutes.scheduleAssigment:
                builder = (BuildContext context) => ScheduleAssigmentView();
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
      ),
    );
  }
}
