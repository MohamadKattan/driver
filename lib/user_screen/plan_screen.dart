
import 'package:driver/user_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/driver_model_provider.dart';
import 'card_payment_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late int amountPlan1 ;
  late  int amountPlan2 ;
  late int amountPlan3 ;

  @override
  Widget build(BuildContext context) {
  final info = Provider.of<DriverInfoModelProvider>(context).driverInfo;
    return WillPopScope(
      onWillPop: ()async=> false ,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(onPressed: (){
                info.status=="payed"?
                Navigator.pop(context)
                    : Navigator.push(context,MaterialPageRoute(builder: (_)=>const SplashScreen()));
              }, icon: const Icon(Icons.arrow_back_ios)),
              backgroundColor: const Color(0xFFFFD54F),
              title:  Text(AppLocalizations.of(context)!.paymentScreen,
                  style:const TextStyle(color: Colors.white)),
            ),
            body: SingleChildScrollView(child: Column(
              children:   [
                const SizedBox(height:8.0),
                 Text(AppLocalizations.of(context)!.planChoose,
                  style:const TextStyle(color: Colors.black45,fontSize: 16.0)),
                const SizedBox(height:8.0),
                GestureDetector(
                  onTap: (){
                    checkamout1(info.carType,context,info.country);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 25 / 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        boxShadow: [
                          BoxShadow(
                            color:  Colors.blueAccent.shade700,
                            spreadRadius: 6.0,
                            blurRadius: 0.6,
                            offset: const Offset(0.7,0.7)
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(AppLocalizations.of(context)!.plan1,style:
                            TextStyle(color:Colors.blueAccent.shade700,
                                fontSize:20.0,fontWeight: FontWeight.bold)),
                          ),
                           Text(AppLocalizations.of(context)!.working30day,
                            style:const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black45
                            )),
                          const SizedBox(height: 40.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                             Text(AppLocalizations.of(context)!.cost,style:const TextStyle(color: Colors.black45,fontSize:20.0)),
                              info.country =="Turkey"?
                              Text(info.carType=="Taxi-4 seats"?" TL 180":"TL 300",style: TextStyle(color: Colors.blueAccent.shade700,fontSize: 20.0,fontWeight: FontWeight.bold))
                                  :Text(info.carType=="Taxi-4 seats"?" \$10":"\$20",style: TextStyle(color: Colors.blueAccent.shade700,fontSize: 20.0,fontWeight: FontWeight.bold)

                              )
                          ],)
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>checkAmount2(info.carType,context,info.country),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 25 / 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color:  Colors.greenAccent.shade700,
                                spreadRadius: 6.0,
                                blurRadius: 0.6,
                                offset: const Offset(0.7,0.7)
                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(AppLocalizations.of(context)!.plan2,style:
                            TextStyle(color:Colors.greenAccent.shade700,
                                fontSize:20.0,fontWeight: FontWeight.bold)),
                          ),
                           Text(AppLocalizations.of(context)!.working90day,
                              style:const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black45
                              )),
                          const SizedBox(height: 40.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                               Text(AppLocalizations.of(context)!.cost,style:const TextStyle(color: Colors.black45,fontSize:20.0)),
                              info.country =="Turkey"?
                              Text(info.carType=="Taxi-4 seats"?" TL 470":"TL 800",style: TextStyle(color: Colors.greenAccent.shade700,fontSize: 20.0,fontWeight: FontWeight.bold))
                                  : Text(info.carType=="Taxi-4 seats"?" \$ 30":"\$ 55",style: TextStyle(color: Colors.greenAccent.shade700,fontSize: 20.0,fontWeight: FontWeight.bold))
                            ])
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>checkAmount3(info.carType,context,info.country),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 25 / 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color:  Colors.purple.shade700,
                                spreadRadius: 6.0,
                                blurRadius: 0.6,
                                offset: const Offset(0.7,0.7)
                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(AppLocalizations.of(context)!.plan3,style:
                            TextStyle(color:Colors.purple.shade700,
                                fontSize:20.0,fontWeight: FontWeight.bold)),
                          ),
                           Text(AppLocalizations.of(context)!.working180day,
                              style:const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black45
                              )),
                          const SizedBox(height: 40.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                               Text(AppLocalizations.of(context)!.cost,style:const TextStyle(color: Colors.black45,fontSize:20.0)),
                              info.country =="Turkey"?
                              Text(info.carType=="Taxi-4 seats"?" TL 800":"TL 1350",style: TextStyle(color: Colors.purple.shade700,fontSize: 20.0,fontWeight: FontWeight.bold))
                                  : Text(info.carType=="Taxi-4 seats"?" \$ 55":"\$ 95",style: TextStyle(color: Colors.purple.shade700,fontSize: 20.0,fontWeight: FontWeight.bold))
                            ],)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ))),
      ),
    );
  }
  void checkamout1(String carType, BuildContext context, String countryName){
    if(countryName == "Turkey"){
      if(carType=="Taxi-4 seats"){
        amountPlan1 =18000;
        // amountPlan1 =180;
      }
      else{
        amountPlan1 = 30000;
        // amountPlan1 = 300;
      }
    }else{
      if(carType=="Taxi-4 seats"){
        amountPlan1 =1000;
        // amountPlan1 = 10;
      }else{
        // amountPlan1 = 20;
        amountPlan1 = 2000;
      }
    }
    int _year = DateTime.now().year;
    int _month = DateTime.now().month+1;
    int _day = DateTime.now().day;
    DateTime _datePlan = DateTime(_year, _month, _day);

    Navigator.push(context,
        MaterialPageRoute(builder:(_)=> CardPaymentScreen(amount: amountPlan1,planexpirt:43200,planDateExpirt:_datePlan)));
  }

  checkAmount2(String carType, BuildContext context,String countryName ) {
    if(countryName == "Turkey"){
      if(carType=="Taxi-4 seats"){
        amountPlan2 =47000;
        // amountPlan2 =470;
      }else{
        amountPlan2 = 70000;
        // amountPlan2 = 700;
      }
    }else{
      if(carType=="Taxi-4 seats"){
        amountPlan2 =3000;
        // amountPlan2 =30;
      }else{
        amountPlan2 = 5500;
        // amountPlan2 = 55;
      }
    }
    int _year = DateTime.now().year;
    int _month = DateTime.now().month+3;
    int _day = DateTime.now().day;
    DateTime _datePlan = DateTime(_year, _month, _day);
    Navigator.push(context,
        MaterialPageRoute(builder:(_)=> CardPaymentScreen(amount: amountPlan2,planexpirt:129600,planDateExpirt: _datePlan)));
  }

  checkAmount3(String carType, BuildContext context,String countryName) {
    if(countryName == "Turkey"){
      if(carType=="Taxi-4 seats"){
        amountPlan3 =80000;
        // amountPlan3 =800;
      }else{
        amountPlan3 = 135000;
        // amountPlan3 = 1350;
      }
    }else{
      if(carType=="Taxi-4 seats"){
        amountPlan3 =5500;
        // amountPlan3 =55;
      }else{
        // amountPlan3 = 95;
        amountPlan3 = 9500;
      }
    }
    int _year = DateTime.now().year;
    int _month = DateTime.now().month+6;
    int _day = DateTime.now().day;
    DateTime _datePlan = DateTime(_year, _month, _day);

    Navigator.push(context,
        MaterialPageRoute(builder:(_)=> CardPaymentScreen(amount: amountPlan3,planexpirt:259200,planDateExpirt:_datePlan)));
  }
}
