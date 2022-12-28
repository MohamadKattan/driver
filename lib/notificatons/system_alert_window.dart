import 'dart:io';
import 'package:system_alert_window/system_alert_window.dart';

///* this class for system dailog alert stopped for now
///if you went to use this plugin check doc for some premising *///
// import 'dart:isolate';
// import 'package:flutter/material.dart';
// import 'package:system_alert_window/system_alert_window.dart';
// import '../tools/background_serv.dart';
//
// bool _isShowingWindow = false;
SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
///not method initPlatformState
// // this method connect with dialog overlay init Platform if want move this void to home screen

// this method connect with  overlay permission
Future<void> requestPermissionsOverlaySystem() async {
  if(Platform.isAndroid){
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }
}
//
//
// bool callBack(String tag) {
//   print("Got tag " + tag);
//   SendPort? port = IsolateManager.lookupPortByName();
//   port?.send([tag]);
//   return true;
// }
//
//
// // this method connect with dailog overlay action
// Future<void>checkOnclick()async{
//   await SystemAlertWindow.checkPermissions;
//   ReceivePort _port = ReceivePort();
//   IsolateManager.registerPortWithName(_port.sendPort);
//   _port.listen((dynamic callBackData) async {
//     String tag= callBackData[0];
//     switch (tag) {
//       case "simple_button":
//         // stopSound();
//        SystemAlertWindow.closeSystemWindow(
//             prefMode: SystemWindowPrefMode.OVERLAY);
//         break;
//       case "focus_button":
//        // stopSound();
//         openDailog();
//         SystemAlertWindow.closeSystemWindow(
//             prefMode: SystemWindowPrefMode.OVERLAY);
//         break;
//     }
//   });
//  SystemAlertWindow.registerOnClickListener(callBack);
// }
//
// // this method for show dailog over lay
// void showOverlayWindow() {
//   if (!_isShowingWindow) {
//     SystemWindowHeader header = SystemWindowHeader(
//         title: SystemWindowText(
//             text: "New Ride Request", fontSize: 20, textColor: Colors.black45),
//         padding: SystemWindowPadding.setSymmetricPadding(12, 60),
//         decoration: SystemWindowDecoration(startColor: Colors.grey[100]));
//     SystemWindowBody body = SystemWindowBody(
//       rows: [
//         EachRow(
//             columns: [
//               EachColumn(
//                 text: SystemWindowText(
//                     text: "PickUp location :",
//                     fontSize: 18,
//                     textColor: Colors.black45),
//               ),
//               EachColumn(
//                 text: SystemWindowText(
//                     text: "............",
//                     fontSize: 18,
//                     textColor: Colors.black45),
//               ),
//             ],
//             gravity: ContentGravity.LEFT,
//             padding:
//             SystemWindowPadding(left: 0, right: 0, top: 20, bottom: 20)),
//         EachRow(columns: [
//           EachColumn(
//               text: SystemWindowText(
//                   text: "DropOff : ",
//                   fontSize: 18,
//                   textColor: Colors.black45,
//                   fontWeight: FontWeight.BOLD),
//               padding: SystemWindowPadding.setSymmetricPadding(6, 8),
//               margin: SystemWindowMargin(top: 4)),
//           EachColumn(
//               text: SystemWindowText(
//                   text: ".........",
//                   fontSize: 18,
//                   textColor: Colors.black45,
//                   fontWeight: FontWeight.BOLD),
//               padding: SystemWindowPadding.setSymmetricPadding(6, 8),
//               margin: SystemWindowMargin(top: 4)),
//         ], gravity: ContentGravity.LEFT),
//         EachRow(
//           columns: [
//             EachColumn(
//                 text: SystemWindowText(
//                     text: "k.m : ",
//                     fontSize: 18,
//                     textColor: Colors.black45,
//                     fontWeight: FontWeight.BOLD),
//                 padding: SystemWindowPadding(
//                     left: 10, right: 20, top: 0, bottom: 0)),
//             EachColumn(
//               text: SystemWindowText(
//                   text: "Fare: ",
//                   fontSize: 18,
//                   textColor: Colors.black45,
//                   fontWeight: FontWeight.BOLD,
//                   padding: SystemWindowPadding(
//                       left: 20, right: 10, top: 0, bottom: 0)),
//             ),
//           ],
//           gravity: ContentGravity.CENTER,
//           margin: SystemWindowMargin(top: 8),
//         ),
//       ],
//       padding: SystemWindowPadding(left: 16, right: 16, bottom: 12, top: 12),
//     );
//     SystemWindowFooter footer = SystemWindowFooter(
//         buttons: [
//           SystemWindowButton(
//             text: SystemWindowText(
//                 text: "Cancel", fontSize: 12, textColor: Colors.white),
//             tag: "simple_button",
//             width: 0,
//             padding:
//             SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
//             height: SystemWindowButton.WRAP_CONTENT,
//             decoration: SystemWindowDecoration(
//                 startColor: Color.fromRGBO(250, 139, 97, 1),
//                 endColor: Color.fromRGBO(247, 28, 88, 1),
//                 borderWidth: 0,
//                 borderRadius: 30.0),
//           ),
//           SystemWindowButton(
//             text: SystemWindowText(
//                 text: "Accepted", fontSize: 12, textColor: Colors.white),
//             tag: "focus_button",
//             width: 0,
//             padding:
//             SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
//             height: SystemWindowButton.WRAP_CONTENT,
//             decoration: SystemWindowDecoration(
//                 startColor: Colors.greenAccent,
//                 endColor: Colors.greenAccent.shade700,
//                 borderWidth: 0,
//                 borderRadius: 30.0),
//           )
//         ],
//         padding: SystemWindowPadding(left: 16, right: 16, top: 12, bottom: 12),
//         decoration: SystemWindowDecoration(startColor: Colors.white),
//         buttonsPosition: ButtonPosition.CENTER);
//     SystemAlertWindow.showSystemWindow(
//         height: 350,
//         width: 275,
//         header: header,
//         body: body,
//         footer: footer,
//         margin: SystemWindowMargin(left: 8, right: 8, top: 0, bottom: 0),
//         gravity: SystemWindowGravity.CENTER,
//         notificationTitle: "New ride request",
//         notificationBody: "pick up now",
//         prefMode: prefMode);
//     _isShowingWindow = true;
//   } else {
//     _isShowingWindow = false;
//     SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
//   }
// }
