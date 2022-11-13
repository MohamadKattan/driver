
import 'dart:io';

import 'package:driver/user_screen/plan_screen.dart';
import 'package:driver/user_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../repo/dataBaseReal_sev.dart';

class IfYouWantPay extends StatelessWidget {
  const IfYouWantPay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataBaseReal().listingForChangeInStatus(context);
    return WillPopScope(
      onWillPop: () async=>false,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                const SizedBox(height: 20.0),
                 Padding(
                  padding:const  EdgeInsets.all(8.0),
                  child:  Text(AppLocalizations.of(context)!.planFinished,style: const TextStyle(color: Colors.black45,fontSize:20.0)),
                ),
                Center(
                    child: Lottie.asset(
                        'images/8434-nfc-payment.json',
                        height: 300,
                        width: 300)),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text(AppLocalizations.of(context)!.chargeNow,style: TextStyle(color: Colors.greenAccent.shade700,fontSize:24.0)),
                 ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(
                          builder:(_)=>const PlanScreen()));
                    }
                  ,child: Container(
                    height: MediaQuery.of(context).size.height*8/100,
                    width: MediaQuery.of(context).size.width*70/100,
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(6.0)
                    ),
                    child:  Center(child: Text(AppLocalizations.of(context)!.toPayment,style:const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: (){
                        if(Platform.isAndroid){
                          SystemNavigator.pop();
                        }else{
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(_)=>const SplashScreen()), (route) => false);
                        }
                      }
                      ,child: Container(
                    height: MediaQuery.of(context).size.height*8/100,
                    width: MediaQuery.of(context).size.width*70/100,
                    decoration: BoxDecoration(
                        color: Colors.redAccent.shade700,
                        borderRadius: BorderRadius.circular(6.0)
                    ),
                    child: Center(child:  Text(AppLocalizations.of(context)!.notNow,style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
                  )),
                )
              ],
            ),),
        ),
      ),
    );
  }
}
