import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
// import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:greenify/aws/amplifyconfiguration.dart';
// import 'package:flutter_aws_s3/amplifyconfiguration.dart';

class Auth extends ChangeNotifier {
  bool isSignUpComplete = false;
  bool isSignedIn = false;
  String? username;

  Auth() {
    configureCognitoPluginWrapper();
  }

  Future<void> configureCognitoPluginWrapper() async {
    await configureCognitoPlugin();
  }

  Future<void> configureCognitoPlugin() async {
    // Add Plugins
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyStorageS3 storagePlugin = AmplifyStorageS3();

    await Amplify.addPlugins([
      authPlugin,
      storagePlugin,
    ]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }

    Amplify.Hub.listen([HubChannel.Auth] as HubChannel<dynamic, HubEvent<Object?>>, (hubEvent) {
      switch (hubEvent.eventName) {
        case "SIGNED_IN":
          print("USER IS SIGNED IN");
          break;
        case "SIGNED_OUT":
          print("USER IS SIGNED OUT");
          break;
        case "SESSION_EXPIRED":
          print("USER IS SIGNED IN");
          break;
      }
    });
  }

  /// Signup a User
  Future<void> signUp(String username, String password, String email) async {
    try {
      Map<String, String> userAttributes = {
        "email": email,
        "phone_number": "",
      };

      SignUpResult res = await Amplify.Auth.signUp(
        username: username,
        password: password,
        // ignore: deprecated_member_use
        options: CognitoSignUpOptions(
        
        ),
      );

      isSignUpComplete = res.isSignUpComplete;
    } on AuthException catch (e) {
      throw (e);
    } catch (error) {
      throw (error);
    }
  }

  /// Confirm User
  Future<void> confirm(String username, String confirmationCode) async {
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode,
      );

      isSignUpComplete = res.isSignUpComplete;
    } on AuthException catch (e) {
      throw (e);
    } catch (error) {
      throw (error);
    }
  }

  /// Signin a User
  Future<void> signIn(String username, String password) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      isSignedIn = true;
    } on AuthException catch (e) {
      throw (e);
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> _isSignedIn() async {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  }

  // Sign Out the User.
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      isSignedIn = false;
    } on AuthException catch (e) {
      throw (e);
    }
  }

  Future<String> fetchSession() async {
    try {
      AuthSession session = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );

      return session.isSignedIn.toString();
    } on AuthException catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<String> getCurrentUser() async {
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      return res.username;
    } on AuthException catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<List<AuthUserAttribute>> getUserAttributes() async {
    List<AuthUserAttribute> attributes = [];

    if (await _isSignedIn()) {
      attributes = await Amplify.Auth.fetchUserAttributes();
    }
    return attributes;
  }
}
