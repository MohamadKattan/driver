
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../tools/url_lunched.dart';
import '../widget/call_us_phone_whatApp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:const Color(0xFF00A3E0),
        appBar: AppBar(
          backgroundColor:const Color(0xFFFBC408),
          title:  Text( AppLocalizations.of(context)!.contactus,style:const TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            const SizedBox(height:40.0),
            const Text("Garanti taxi driver",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                )),
             Padding(
              padding:const EdgeInsets.all(8.0),
              child: Text( AppLocalizations.of(context)!.anyquestion,
                  style:const TextStyle(fontSize: 16.0, color: Colors.white70),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => ToUrlLunch().toUrlEmail(),
              child: Container(
                padding:const  EdgeInsets.all(8.0),
                margin:const  EdgeInsets.only(left: 8.0,right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(width: 2.0,color: Colors.white70)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(Icons.email, color: Color(0xFFFBC408), size: 35.0),
                    SizedBox(width: 6.0),
                    Text("vba@garantitaxi.com",
                        style: TextStyle(color: Colors.black45, fontSize: 24.0))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.or,
                  style: TextStyle(
                      color: Colors.redAccent.shade700, fontSize: 20.0,fontWeight: FontWeight.bold)),
            ),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => callUs(context),
              ),
              child: Container(
                padding:const  EdgeInsets.all(8.0),
                margin:const  EdgeInsets.only(left: 8.0,right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(width: 2.0,color: Colors.white70)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.call, color: Colors.green.shade700,size: 35),
                    const SizedBox(width: 6.0),
                    const Text("5057743644",style: TextStyle(color: Colors.black45,fontSize: 24),)
                  ],
                ),
              ),
            ),
            Center(
              child: Lottie.asset(
                'images/58738-quad-cube-shifter-2.json',
                height: MediaQuery.of(context).size.height * 35 / 100,
                width: MediaQuery.of(context).size.width * 35 / 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
