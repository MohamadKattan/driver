// this widget for call us

import 'package:flutter/material.dart';
import '../tools/url_lunched.dart';
import 'custom_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Widget callUs(
    BuildContext context) {
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height * 25 / 100,
      width: double.infinity,
      decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(6.0)
          ,color: Colors.white),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                AppLocalizations.of(context)!.uss,
                style:const TextStyle(
                    color: Colors.black87,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap:(){
                    Navigator.pop(context);
                    ToUrlLunch().toCallLunch(phoneNumber:"+905366034616");

                  },
                  child: Row(
                    children:  [
                     const Icon(Icons.phone,size: 24.0,color: Colors.greenAccent,),
                     const SizedBox(width: 6.0),
                      Text(AppLocalizations.of(context)!.normalCall + "+905366034616",
                          style:
                         const TextStyle(color: Colors.black87, fontSize: 16.0)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap:(){
                    Navigator.pop(context);
                    ToUrlLunch().toUrlLunch(url:"https://wa.me/+905366034616");
                  },
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.green.shade700,radius: 15.0,child: const Icon(Icons.phone,size: 15.0,color: Colors.white)),
                      const SizedBox(width: 6.0),
                      const Text(" What app  : +905366034616 ",
                          style:
                          TextStyle(color: Colors.black87, fontSize: 16.0)),
                    ],
                  ),
                ),
              ),
              CustomDivider().customDivider(),
              SizedBox(height: MediaQuery.of(context).size.height * 3.5 / 100),
            ],
          ),
        ),
      ),
    ),
  );
}