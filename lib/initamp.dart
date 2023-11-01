import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:greenify/aws/amplifyconfiguration.dart';

class InitAmp {
  static bool isAmplifyConfigured = false;

  static Future<void> configureAmplify() async {
    if (!isAmplifyConfigured) {
      try {
        final auth = AmplifyAuthCognito();
        final storage = AmplifyStorageS3();
        await Amplify.addPlugins([auth, storage]);

        // call Amplify.configure to use the initialized categories in your app
        await Amplify.configure(amplifyconfig);

        isAmplifyConfigured = true;
      } on Exception catch (e) {
        safePrint('An error occurred configuring Amplify: $e');
      }
    }
  }
}
