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
  Future<void> toCallLunch({required String phoneNumber}) async {
    // if (!await launch(url)) throw 'Could not launch $url';
    await canLaunch("tel:$phoneNumber")
        ? launch("tel:$phoneNumber")
        : Tools().toastMsg('Could not launch $phoneNumber');
  }
}
