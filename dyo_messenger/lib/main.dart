import 'package:dyo_messenger/models/conservation.dart';
import 'package:dyo_messenger/models/contact.dart';
import 'package:dyo_messenger/models/sms.dart';
import 'package:dyo_messenger/models/sms_type.dart';
import 'package:dyo_messenger/screens/home.dart';
import 'package:dyo_messenger/services/sms_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ConservationAdapter());
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(SmsTypeAdapter());
  Hive.registerAdapter(SmsAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: Hive.openBox('conservations'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return HomeScreen();
            }
          } else {
            return Scaffold();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            List<Sms> sms = await SmsServcie.getAllSms();
          },
        ),
      ),
    );
  }

  //PERMISSION
  Future<void> _askPermissions() async {
    await [
      Permission.sms,
      Permission.contacts,
    ].request();
  }
}
