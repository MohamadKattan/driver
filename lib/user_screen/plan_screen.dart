
import 'package:driver/user_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/driver_model_provider.dart';
import 'card_payment_screen.dart';

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
              title: const Text("Payment screen",
                  style: TextStyle(color: Colors.white)),
            ),
            body: SingleChildScrollView(child: Column(
              children:   [
                const SizedBox(height:8.0),
                const Text("We have for you 3 plan choose as you like ",
                  style: TextStyle(color: Colors.black45,fontSize: 16.0)),
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
                            child: Text("Plan 1",style:
                            TextStyle(color:Colors.blueAccent.shade700,
                                fontSize:20.0,fontWeight: FontWeight.bold)),
                          ),
                          const Text("This plan working for 30 day",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black45
                            )),
                          const SizedBox(height: 40.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                            const Text("Cost : ",style: TextStyle(color: Colors.black45,fontSize:20.0)),
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
                            child: Text("Plan 2",style:
                            TextStyle(color:Colors.greenAccent.shade700,
                                fontSize:20.0,fontWeight: FontWeight.bold)),
                          ),
                          const Text("This plan working for 90 day",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black45
                              )),
                          const SizedBox(height: 40.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              const Text("Cost : ",style: TextStyle(color: Colors.black45,fontSize:20.0)),
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
                            child: Text("Plan 3",style:
                            TextStyle(color:Colors.purple.shade700,
                                fontSize:20.0,fontWeight: FontWeight.bold)),
                          ),
                          const Text("This plan working for 6 month",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black45
                              )),
                          const SizedBox(height: 40.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              const Text("Cost : ",style: TextStyle(color: Colors.black45,fontSize:20.0)),
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
      }else{
        amountPlan1 = 30000;
      }
    }else{
      if(carType=="Taxi-4 seats"){
        amountPlan1 =1000;
      }else{
        amountPlan1 = 2000;
      }
    }

    Navigator.push(context,
        MaterialPageRoute(builder:(_)=> CardPaymentScreen(amount: amountPlan1,planexpirt: 30,)));
  }

  checkAmount2(String carType, BuildContext context,String countryName ) {
    if(countryName == "Turkey"){
      if(carType=="Taxi-4 seats"){
        amountPlan2 =47000;
      }else{
        amountPlan2 = 70000;
      }
    }else{
      if(carType=="Taxi-4 seats"){
        amountPlan2 =3000;
      }else{
        amountPlan2 = 5500;
      }
    }
    Navigator.push(context,
        MaterialPageRoute(builder:(_)=> CardPaymentScreen(amount: amountPlan2,planexpirt: 90)));
  }

  checkAmount3(String carType, BuildContext context,String countryName) {
    if(countryName == "Turkey"){
      if(carType=="Taxi-4 seats"){
        amountPlan3 =80000;
      }else{
        amountPlan3 = 135000;
      }
    }else{
      if(carType=="Taxi-4 seats"){
        amountPlan3 =5500;
      }else{
        amountPlan3 = 9500;
      }
    }
    Navigator.push(context,
        MaterialPageRoute(builder:(_)=> CardPaymentScreen(amount: amountPlan3,planexpirt: 180)));
  }
}
