
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../user_screen/auth_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget pageViewContent(BuildContext context, String image, String title,
    PageController controller) {
  return Stack(
    children: [
      Image.asset(
        image,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          color: Colors.white,
          height: 275,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF00A3E0),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
              axisDirection: Axis.horizontal,
              effect: const WormEffect(
                activeDotColor: Color(0xFFFBC408),
              ),
            ),
          ),
        ),
      ),
      Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()));
                },
                child: Text(AppLocalizations.of(context)!.skip,
                    style: const TextStyle(
                        color: Color(0xFF00A3E0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
          )),
    ],
  );
}
