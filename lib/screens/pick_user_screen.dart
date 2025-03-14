import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/pick_user_card.dart';
import '../widgets/header.dart';
import 'login_screen.dart';
import 'login_reclutador_screen.dart';

class PickUserScreen extends StatefulWidget {
  const PickUserScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PickUserScreen();
}

class _PickUserScreen extends State<PickUserScreen> {
  void _onButtonPressed(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginReclutadorScreen()), //Reclutador
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), //Estudiante
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Header(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "¿Quién soy?",
                  style: TextStyle(
                    color: Color(0xff1E3984),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                PickUserCard(
                  title: "Reclutador",
                  imagePath: 'assets/recruiter_login_image.jpg',
                  onPressed: () {
                    _onButtonPressed(0);
                  },
                ),
                const SizedBox(height: 20),
                PickUserCard(
                  title: "Estudiante",
                  imagePath: 'assets/student_login_image.jpg',
                  onPressed: () {
                    _onButtonPressed(1);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}