import 'package:driver/user_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RefreshAfterActived extends StatelessWidget {
  const RefreshAfterActived({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:const Color(0xFFFFD54F),
          title:  Text( AppLocalizations.of(context)!.activeAccount,style:const TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            const SizedBox(height:40.0),
            const Text("Garanti taxi driver",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 45,
                )),
            Padding(
              padding:const EdgeInsets.all(8.0),
              child: Text( AppLocalizations.of(context)!.activeAccountDon,
                  style:const TextStyle(fontSize: 16.0, color: Colors.greenAccent),textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () =>Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder:(_)=>const SplashScreen()), (route) => false),
                child:Container(
                height: 60,
                width: 120,
                decoration:
                BoxDecoration(
                    color: Colors.greenAccent.shade700,
                  borderRadius: BorderRadius.circular(6)
                ),
                child:Center(child: Text(AppLocalizations.of(context)!.active,style: const TextStyle(color: Colors.white),))
              )
            ),
          ],
        ),
      ),
    );
  }
}
