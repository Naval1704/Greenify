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

void main() {
  runApp(const MyApp());
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
    _configureAmplify();
  }

  void _configureAmplify() async {
    final authPlugin = AmplifyAuthCognito(
      // FIXME: In your app, make sure to remove this line and set up
      /// Keychain Sharing in Xcode as described in the docs:
      /// https://docs.amplify.aws/lib/project-setup/platform-setup/q/platform/flutter/#enable-keychain
      secureStorageFactory: AmplifySecureStorage.factoryFrom(
        macOSOptions:
            // ignore: invalid_use_of_visible_for_testing_member
            MacOSSecureStorageOptions(useDataProtection: false),
      ),
    );
    await Amplify.addPlugins([
      authPlugin,AmplifyStorageS3(),AmplifyDataStore(modelProvider: ModelProvider.instance),
      // FIXME: In your app, make sure to run `amplify codegen models` to generate
      // the models and provider
     
    ]);

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
        'Amplify was already configured. Looks like app restarted on android.',
      );
    }
    setState(() {
      _isAmplifyConfigured = true;
    });

    Amplify.Hub.listen(
      HubChannel.Api,
      (ApiHubEvent event) {
        if (event is SubscriptionHubEvent) {
          safePrint(event);
        }
      },
    );
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
