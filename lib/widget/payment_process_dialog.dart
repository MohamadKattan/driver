import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget paymentProcess(BuildContext context,
    {required VoidCallback voidCallback}) {
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xFF00A3E0)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.paymentProcess,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  voidCallback();
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: Text(AppLocalizations.of(context)!.ok,
                          style:
                              TextStyle(color: Colors.greenAccent.shade700))),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
