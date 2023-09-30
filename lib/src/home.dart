import 'package:buzpres/src/pres/creator/pres_creator.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PresCreatorView(),
    );
  }
}
