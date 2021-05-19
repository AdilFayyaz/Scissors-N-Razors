import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final _firestore = FirebaseFirestore.instance;
  final key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //  firebaseMessaging.getToken().then((token) {
    //  saveTokens(token);
    //});

    firebaseMessaging.configure(
      //called when app is in foreground
      onMessage: (Map<String, dynamic> message) async {
        print('init called onMessage');
        final snackBar = SnackBar(
          content: Text(message['notification']['body']),
          action: SnackBarAction(label: 'GO', onPressed: () {}),
        );
        key.currentState.showSnackBar(snackBar);
      },
      //called when app is completely closed and open from push notification
      onLaunch: (Map<String, dynamic> message) async {
        print('init called onLaunch');
      },
      //called when app is in background  and open from push notification

      onResume: (Map<String, dynamic> message) async {
        print('init called onResume');
      },
    );

  }

  Future<void> saveTokens(var token) async {
    try {
      await _firestore.collection('tokens').add({
        'token': token,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text('Push Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}