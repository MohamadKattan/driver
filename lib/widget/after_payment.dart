import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'custom_divider.dart';

Widget afterPayment(BuildContext context) {
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: 225,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0), color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.daygift,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.greenAccent.shade700,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.checkBank,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: Colors.black87, fontSize: 16.0)),
            ),
            const SizedBox(height: 2),
            CustomDivider().customDivider(),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    width: 90,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.greenAccent.shade700),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.ok,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
