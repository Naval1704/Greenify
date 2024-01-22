// import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:greenify/aws/amplifyconfiguration.dart';
import 'package:greenify/ff/login_page.dart';
import 'package:greenify/ff/start_page.dart';
import 'package:greenify/models/ModelProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const MyApp());
}

 Future<void> _configureAmplify() async {
    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugins([
      authPlugin,AmplifyStorageS3(),AmplifyAPI(),AmplifyDataStore(modelProvider: ModelProvider.instance)]);

    try {
      await Amplify.configure(amplifyconfig);
      // await Amplify.DataStore.clear(); 
      await Future.delayed(const Duration(seconds: 1)); 
      await Amplify.DataStore.start();
    } on AmplifyAlreadyConfiguredException {
      print(
        'Amplify was already configured. Looks like app restarted on android.',
      );
    }
    // setState(() {
    //   _isAmplifyConfigured = true;
    // });

    Amplify.Hub.listen(
      HubChannel.Api,
      (ApiHubEvent event) {
        if (event is SubscriptionHubEvent) {
          safePrint(event);
        }
      },
    );
  }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAmplifyConfigured = false;
  bool _showRestApiView = true;

  @override
  void initState() {
    super.initState();
    // _configureAmplify();
  }

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Greenify',
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => Authenticator(
              child:
                  const StartPage(), // Map the root route to the StartPage wrapped in Authenticator
            ),
        '/login': (context) => Authenticator(
              child:
                  const LoginPage(), // Map the login route to the LoginPage wrapped in Authenticator
            ),
        // Add more routes as needed
      },
    );
  }
}
