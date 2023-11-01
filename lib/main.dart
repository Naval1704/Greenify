import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:greenify/aws/amplifyconfiguration.dart';
import 'package:greenify/ff/login_page.dart';
import 'package:greenify/ff/start_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3()]);
      await Amplify.configure(amplifyconfig);
      safePrint('Successfully configured');
    } on Exception catch (e) {
      safePrint('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Greenify',
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => Authenticator(
              child: const StartPage(), // Map the root route to the StartPage wrapped in Authenticator
            ),
        '/login': (context) => Authenticator(
              child: const LoginPage(), // Map the login route to the LoginPage wrapped in Authenticator
            ),
        // Add more routes as needed
      },
    );
  }
}
