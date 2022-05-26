// this method for check currency type connect to country



import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../my_provider/driver_model_provider.dart';

 String currencyTypeCheck(BuildContext context){
  final driverInfo=Provider.of<DriverInfoModelProvider>(context, listen: false)
          .driverInfo;
 String _currencyType = "";
 if(driverInfo.country=="Turkey"&&driverInfo.carType=="Taxi-4 seats"){
   _currencyType="TL";
 }else if(driverInfo.country=="Turkey"&&driverInfo.carType=="Medium commercial-6-10 seats"){
   _currencyType="\$";
 }else if(driverInfo.country=="Turkey"&&driverInfo.carType=="Big commercial-11-19 seats"){
   _currencyType="\$";
 }else if(driverInfo.country=="Morocco"){
   _currencyType=="MAD";
 }else if(driverInfo.country=="Sudan"){
   _currencyType=="SUP";
 }else if(driverInfo.country=="Saudi Arabia"){
   _currencyType=="SAR";
 }else if(driverInfo.country=="Qatar"){
   _currencyType=="QAR";
 }else if(driverInfo.country=="Libya"){
   _currencyType=="LYD";
 }else if(driverInfo.country=="Kuwait"){
   _currencyType=="KWD";
 }else if(driverInfo.country=="Iraq"){
   _currencyType=="\$";
 }else if(driverInfo.country=="United Arab Emirates"){
   _currencyType=="AED";
 }else{
   _currencyType=="\$";
 }
return _currencyType;
}