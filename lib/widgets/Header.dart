import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Provider.of<AppState>(context).darkMode;

    String svgPath = darkMode ? "images/icon-sun.svg" : "images/icon-moon.svg";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(20.00),
          child: const Text(
            "T O D O",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Josefin Sans",
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Provider.of<AppState>(context, listen: false).toggleDarkMode();
          },
          child: Container(
            padding: const EdgeInsets.all(20.00),
            child: SvgPicture.asset(svgPath),
          ),
        )
      ],
    );
  }
}
