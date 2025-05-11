import 'package:flutter/material.dart';
import 'home_screen_api.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // Display the API-integrated home screen
    return const HomeScreenApi();
  }
}
