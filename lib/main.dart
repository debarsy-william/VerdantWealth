import 'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'pages/login/LogoScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid);

const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: kBackgroundColorGreen, // Couleur de fond de la barre de navigation
          systemNavigationBarIconBrightness: Brightness.light, // Couleur des icônes sur la barre de navigation
        ),
        child: LogoScreen(),
      ),
    );
  }
}



