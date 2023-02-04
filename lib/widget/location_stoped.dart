import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Widget locationStoped(BuildContext context) {
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.red.shade700),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.reOpen,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 8.0, bottom: 8.0),
                  alignment: Alignment.center,
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
