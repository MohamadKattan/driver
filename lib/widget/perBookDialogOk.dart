// this dialog after preBooking okay and don

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/change_color_bottom.dart';
import '../my_provider/drawer_value_provider.dart';
import '../tools/url_lunched.dart';
import 'custom_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Widget preBookOkay(
    BuildContext context) {
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: 150,
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
              Center(
                child: Text(
                  AppLocalizations.of(context)!.preBookOkay,
                  textAlign: TextAlign.center,
                  style:const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: (){
                  Provider.of<DrawerValueChange>(context, listen: false)
                      .updateValue(0);
                  Provider.of<ChangeColorBottomDrawer>(context, listen: false)
                      .updateColorBottom(false);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 8 / 100,
                  width: MediaQuery.of(context).size.width * 60 / 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBC408),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.ok,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),

            ],
          ),
        ),
      ),
    ),
  );
}