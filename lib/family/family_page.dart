import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'ExpertPage.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:greenify/amplifyconfiguration.dart';

class FamilyPage extends StatefulWidget {
  FamilyPage({Key? key}) : super(key: key);
  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      safePrint('Successfully configured');
    } on Exception catch (e) {
      safePrint('Error configuring Amplify: $e');
    }
  }

  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ExpertPage(),
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp.router(
        theme: ThemeData.from(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
          ),
        ).copyWith(
          indicatorColor: Colors.red,
        ),

        // set the theme mode to respond to the user's system preferences (optional)
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        builder: Authenticator.builder(),
      ),
    );
  }
}
