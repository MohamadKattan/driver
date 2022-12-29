import 'package:driver/user_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RefreshAfterActived extends StatelessWidget {
  const RefreshAfterActived({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF00A3E0),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFFBC408),
          title: Text(AppLocalizations.of(context)!.activeAccount,
              style: const TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            const SizedBox(height: 40.0),
            const Text("Garanti taxi driver",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.activeAccountDon,
                  style: const TextStyle(fontSize: 20.0, color: Colors.white70),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const SplashScreen()),
                    (route) => false),
                child: Container(
                    height: 60,
                    width: 200,
                    decoration: BoxDecoration(
                        color: const Color(0xFFFBC408),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.active,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )))),
          ],
        ),
      ),
    );
  }
}
