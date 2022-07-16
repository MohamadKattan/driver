// this class for urlLunched method

import 'dart:io';

import 'package:driver/tools/tools.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ToUrlLunch {
  Future<void> toUrlLunch({required String url}) async {
    // if (!await launch(url)) throw 'Could not launch $url';
    await canLaunch(url)
        ? launch(url)
        : Tools().toastMsg('Could not launch $url', Colors.redAccent.shade700);
  }

  Future<void> toPlayStore() async {
    // if (!await launch(url)) throw 'Could not launch $url';
    if(Platform.isAndroid){
      await canLaunch("https://play.google.com/store/apps/details?id=com.garanti.garantitaxidriver&hl=tr")
          ? launch("https://play.google.com/store/apps/details?id=com.garanti.garantitaxidriver&hl=tr")
          : Tools().toastMsg('Could not launch ', Colors.redAccent.shade700);
    }else{
      await canLaunch("https://www.apple.com/tr/app-store/")
          ? launch("https://www.apple.com/tr/app-store/")
          : Tools().toastMsg('Could not launch ', Colors.redAccent.shade700);
    }
  }

  Future<void> toCallLunch({required String phoneNumber}) async {
    // if (!await launch(url)) throw 'Could not launch $url';
    await canLaunch("tel:$phoneNumber")
        ? launch("tel:$phoneNumber")
        : Tools().toastMsg(
            'Could not launch $phoneNumber', Colors.redAccent.shade700);
  }

  Future<void> toUrlEmail() async {
    // if (!await launch(url)) throw 'Could not launch $url';
    await canLaunch("mailto:granti@ouiquit.com")
        ? launch("mailto:granti@ouiquit.com")
        : Tools()
            .toastMsg('Could not launch gmail now ', Colors.redAccent.shade700);
  }
}
