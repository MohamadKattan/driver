
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../my_provider/icon_phone_value.dart';
import '../tools/url_lunched.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phoneIconValue = Provider.of<PhoneIconValue>(context).IconValue;
    return WillPopScope(
      onWillPop: ()async=>false,
      child: SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onTap: () => Provider.of<PhoneIconValue>(context, listen: false)
                  .updateValue(-100.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                            child: Lottie.asset(
                                'images/93505-recruiter-hiring.json',
                                height: 350,
                                width: 350)),
                      ),
                        Center(
                        child: Text(
                          AppLocalizations.of(context)!.checking,
                          style:const TextStyle(
                              fontSize: 30.0,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                       Center(
                        child: Text(
                            AppLocalizations.of(context)!.appreciate,
                          style:const TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                       Center(
                        child: Text(
                            AppLocalizations.of(context)!.sendnot,
                          style:const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      GestureDetector(
                          onTap: () => Provider.of<PhoneIconValue>(context,
                              listen: false)
                              .updateValue(65.0),
                        child: Column(
                          children:  [
                            Center(
                              child: Padding(
                                padding:const EdgeInsets.only(top: 25.0),
                                child: Text(
                                  AppLocalizations.of(context)!.moreinfo,
                                  style:const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                  AppLocalizations.of(context)!.click,
                                style:const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
                right: 0.0,
                left: 0.0,
                bottom: phoneIconValue,
                child: CircleAvatar(
                  radius: 35.0,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: const Center(
                      child: Icon(
                        Icons.phone_in_talk_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    onPressed: () {
                      ToUrlLunch().toUrlLunch(url:"https://wa.me/+905314517326");
                    },
                  ),
                ),
                duration: const Duration(milliseconds: 300))
          ],
        ),
      )),
    );
  }
}
