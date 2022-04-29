
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../tools/url_lunched.dart';
import '../widget/call_us_phone_whatApp.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:const Color(0xFFFFD54F),
          title: const Text("Contact us",style: TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            const SizedBox(height:40.0),
            const Text("Garanti driver",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 45,
                )),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("For any info or any question connect us",
                  style: TextStyle(fontSize: 16.0, color: Colors.black45)),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => ToUrlLunch().toUrlEmail(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.email, color: Colors.yellow, size: 20.0),
                  SizedBox(width: 6.0),
                  Text("Garanti@gmail.com",
                      style: TextStyle(color: Colors.black45, fontSize: 24.0))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Or",
                  style: TextStyle(
                      color: Colors.redAccent.shade700, fontSize: 20.0,fontWeight: FontWeight.bold)),
            ),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => callUs(context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, color: Colors.green.shade700),
                  const SizedBox(width: 6.0),
                  const Text("00000000000000",style: TextStyle(color: Colors.black45,fontSize: 24),)
                ],
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
