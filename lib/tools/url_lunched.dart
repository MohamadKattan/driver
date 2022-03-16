// this class for urlLunched method

import 'package:driver/tools/tools.dart';
import 'package:url_launcher/url_launcher.dart';

class ToUrlLunch {
  Future<void> toUrlLunch({required String url}) async {
    // if (!await launch(url)) throw 'Could not launch $url';
    await canLaunch(url)
        ? launch(url)
        : Tools().toastMsg('Could not launch $url');
  }
}
