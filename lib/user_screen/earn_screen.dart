
import 'package:driver/repo/dataBaseReal_sev.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../my_provider/driver_model_provider.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({Key? key}) : super(key: key);

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  void initState() {
    DataBaseReal().getDriverInfoFromDataBase(context);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final driverEarn = Provider.of<DriverInfoModelProvider>(context).driverInfo.earning;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0xFFFFD54F),
        title: const Text("My earning",style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset('images/51765-cash.json',fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height*60/100,
                  width: MediaQuery.of(context).size.width*60/100,),
              const Text(
                "Your Total earning",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("\$$driverEarn",style: TextStyle(color: Colors.greenAccent.shade700,fontSize: 24.0),),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
