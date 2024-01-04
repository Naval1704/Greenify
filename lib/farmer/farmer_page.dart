import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/farmer/lobby_page.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:greenify/amplifyconfiguration.dart';

class FarmerPage extends StatefulWidget {
  FarmerPage({Key? key}) : super(key: key);
  @override
  _FarmerPageState createState() => _FarmerPageState();
}

class _FarmerPageState extends State<FarmerPage> {
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
        builder: (context, state) => const LobbyPage(),
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

// child: Container(
//   width: double.infinity,
//   height: double.infinity,
//   decoration: const BoxDecoration(
//     // Gradient Background
//     gradient: LinearGradient(
//       colors: [Color(0xFF1EFF34), Color(0xFF47FF4B), Color(0xFF14FF00)],
//       begin: Alignment.bottomLeft,
//       end: Alignment.topRight,
//     ),
//   ),
//   child: Stack(
//     alignment: const Alignment(0.0, 0.4),
//     children: [
//       Positioned.fill(
//         right: -10,
//         top: -85,
//         bottom: 500,
//         child: Opacity(
//           opacity: 0.9, // Adjust the opacity value as needed
//           child: Image.asset(
//             'assets/watermark.png', // Replace with your watermark image asset
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       SizedBox(
//         width: 300,
//         height: 444,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(30),
//           child: MaterialApp.router(
//             routerConfig: _router,
//             debugShowCheckedModeBanner: false,
//             builder: Authenticator.builder(),
//           ),
//         ),
//       ),
//     ],
//   ),
// ),
