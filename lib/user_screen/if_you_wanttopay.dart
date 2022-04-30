
import 'package:driver/user_screen/plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class IfYouWantPay extends StatelessWidget {
  const IfYouWantPay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async=>false,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                const SizedBox(height: 20.0),
                const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child:  Text("Your plan already finished",style: TextStyle(color: Colors.black45,fontSize:20.0)),
                ),
                Center(
                    child: Lottie.asset(
                        'images/8434-nfc-payment.json',
                        height: 300,
                        width: 300)),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text("Charge now",style: TextStyle(color: Colors.greenAccent.shade700,fontSize:24.0)),
                 ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: ()=>Navigator.push(context,MaterialPageRoute(
                        builder:(_)=>const PlanScreen()))
                  ,child: Container(
                    height: MediaQuery.of(context).size.height*8/100,
                    width: MediaQuery.of(context).size.width*70/100,
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(6.0)
                    ),
                    child: const Center(child: Text("To Payment",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: ()=>SystemNavigator.pop()
                      ,child: Container(
                    height: MediaQuery.of(context).size.height*8/100,
                    width: MediaQuery.of(context).size.width*70/100,
                    decoration: BoxDecoration(
                        color: Colors.redAccent.shade700,
                        borderRadius: BorderRadius.circular(6.0)
                    ),
                    child:const Center(child:  Text("Not now exit ",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
                  )),
                )
              ],
            ),),
        ),
      ),
    );
  }
}
