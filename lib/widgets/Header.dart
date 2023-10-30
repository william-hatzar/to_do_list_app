

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Provider.of<AppState>(context).darkMode;
    String imagePath = darkMode ? "images/bg-mobile-dark.jpeg" : "images/bg-mobile-light.jpeg";
    String svgPath = darkMode ? "images/icon-sun.svg" : "images/icon-moon.svg";
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          child: Container(
            padding: const EdgeInsets.all(20.00),
            child: const Text(
              "T O D O",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Josefin Sans",
                fontWeight: FontWeight.w700,
                fontSize: 35,
              ),
            ),
          ),
        ),
    Positioned(
    top: 50,
    left: 320,
    child: GestureDetector(
    onTap: () {
    Provider.of<AppState>(context, listen: false).toggleDarkMode();
    },
    child: Container(
    padding: const EdgeInsets.all(20.00),
    child: SvgPicture.asset(svgPath),
    ),
    ),
    )
      ],
    );
  }
}