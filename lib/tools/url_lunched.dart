// this class for urlLunched method

import 'dart:io';

import 'package:driver/tools/tools.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ToUrlLunch {

  Future<void> toUrlLunch({required String url}) async {
    var uri = Uri.parse(url);
    // if (!await launch(url)) throw 'Could not launch $url';
    await canLaunchUrl(uri)
        ? launchUrl(uri,mode: LaunchMode.externalApplication)
        : Tools().toastMsg('Could not launch $url', Colors.redAccent.shade700);
  }

  Future<void> toPlayStore() async {
    // if (!await launch(url)) throw 'Could not launch $url';
    var androidUrl = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.garanti.garantitaxidriver&hl=tr");
    var iosUrl = Uri.parse(
        "https://apps.apple.com/tr/app/garantitaxi-driver/id1635534414");
    if (Platform.isAndroid) {
      await canLaunchUrl(androidUrl)
          ? launchUrl(androidUrl,mode: LaunchMode.externalApplication)
          : Tools().toastMsg('Could not launch ', Colors.redAccent.shade700);
    } else {
      await canLaunchUrl(iosUrl)
          ? launchUrl(iosUrl,mode: LaunchMode.externalApplication)
          : Tools().toastMsg('Could not launch ', Colors.redAccent.shade700);
    }
  }

  Future<void> toCallLunch({required String phoneNumber}) async {
    var url = Uri.parse("tel:$phoneNumber");
    await canLaunchUrl(url)
        ? launchUrl(url,mode: LaunchMode.externalApplication)
        : Tools().toastMsg(
            'Could not launch $phoneNumber', Colors.redAccent.shade700);
  }

  Future<void> toUrlEmail() async {
    var url = Uri.parse("mailto:vba@garantitaxi.com");
    await canLaunchUrl(url)
        ? launchUrl(url,mode: LaunchMode.externalApplication)
        : Tools()
            .toastMsg('Could not launch gmail now ', Colors.redAccent.shade700);
  }

  Future<void> toUrlWebSite() async {
    var url = Uri.parse("https://garantitaxi.com");
    await canLaunchUrl(url)
        ? launchUrl(url,mode: LaunchMode.externalApplication)
        : Tools().toastMsg(
            'Could not launch webSite now ', Colors.redAccent.shade700);
  }
}
