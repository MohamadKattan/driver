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
      height: 200,
      width: double.infinity,
      decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(12.0)
          ,color:const Color(0xFF00A3E0)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   Text(
                    AppLocalizations.of(context)!.uss,
                    style:const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
              ),
                   IconButton(onPressed:()=>Navigator.pop(context), icon:Icon(Icons.close,color: Colors.redAccent.shade700,))
                 ],
               ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap:(){
                    Navigator.pop(context);
                    ToUrlLunch().toCallLunch(phoneNumber:"+905057743644");

                  },
                  child: Row(
                    children:  [
                      Icon(Icons.phone,size: 20.0,color: Colors.greenAccent.shade700,),
                     const SizedBox(width: 6.0),
                      Text(AppLocalizations.of(context)!.normalCall + "+905057743644",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style:
                         const TextStyle(color: Colors.white, fontSize: 16.0)),
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
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(color: Colors.white, fontSize: 16.0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}