import 'package:flutter/material.dart';
import 'package:njia/blocs/application_bloc.dart';
import 'package:njia/screens/all_suspects.dart';
import 'package:njia/screens/login_screen.dart';
import 'package:njia/screens/register_screen.dart';
import 'package:njia/screens/home.dart';
import 'package:njia/screens/suspect_map.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class IconFont extends StatelessWidget {
  const IconFont({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Njia',
      style:
          TextStyle(color: Colors.white, fontSize: 100, fontFamily: 'orilla'),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Njia',
        // home: LoginScreen(),
        routes: {
          '/': (BuildContext context) => LoginScreen(),
          '/register': (BuildContext context) => RegisterScreen(),
          '/map': (BuildContext context) => MapSample(),
          '/all_suspect': (BuildContext context) => SuspectPage(),
          '/suspect_map': (BuildContext context) => SuspectMap(),
        },
      ),
    );
  }
}
