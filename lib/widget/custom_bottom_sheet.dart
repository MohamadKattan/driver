// this class for custom bottom sheet use in DriverInfoScreen
import 'dart:io';
import 'package:driver/notificatons/push_notifications_srv.dart';
import 'package:driver/tools/tools.dart';
import 'package:driver/user_screen/check_in_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../my_provider/bottom_sheet_value.dart';
import '../my_provider/driverInfo_inductor.dart';
import '../my_provider/get_image_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:firebase_database/firebase_database.dart';
import '../repo/auth_srv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomSheet {
  final ImagePicker _picker = ImagePicker();
  // late final XFile? image1;
  // late final XFile? image2;
  // late final XFile? image3;
  // late final XFile? image4;
  User? currentUser = AuthSev().auth.currentUser;
  Widget customBottomSheet(
    BuildContext context,
    double bottomSheetValue,
    TextEditingController name,
    TextEditingController lastName,
    TextEditingController idNo,
    TextEditingController carBrand,
    TextEditingController carColor,
    TextEditingController carModel,
    String dropBottomValue,
    String result,
  ) {
    final driverImage = Provider.of<GetImageProvider>(context).personImage;
    final driverLis = Provider.of<GetImageProvider>(context).imageDriverLis;
    final carLisImage = Provider.of<GetImageProvider>(context).imageCarLis;
    final carImage = Provider.of<GetImageProvider>(context).platLis;
    return Container(
      height: MediaQuery.of(context).size.height * 75 / 100,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                spreadRadius: 0.5,
                blurRadius: 7.0,
                offset: Offset(0.7, 0.7))
          ],
          color: Color(0xFF00A3E0),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () =>
                    Provider.of<BottomSheetValue>(context, listen: false)
                        .updateValue(-700.0),
                icon: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 35.0,
                  color: Color(0xFFFBC408),
                )),
            Center(
                child: Text(
              AppLocalizations.of(context)!.approveImages,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )),
            const SizedBox(height: 15.0),
            Container(
              height: MediaQuery.of(context).size.height * 10 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5.0,
                      spreadRadius: 0.7,
                      offset: Offset(0.7, 0.7))
                ],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(AppLocalizations.of(context)!.personnelImage),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await getImage(
                                  ImageSource.camera, context, 'driverImage');
                            },
                            icon: const Icon(Icons.add_a_photo_outlined,
                                size: 35.0, color: Color(0xFFFBC408))),
                        IconButton(
                            onPressed: () async {
                              await getImage(
                                  ImageSource.gallery, context, 'driverImage');
                            },
                            icon: const Icon(Icons.image,
                                size: 35.0, color: Color(0xFFFBC408))),
                        showIconDriverImage(context, driverImage)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              height: MediaQuery.of(context).size.height * 10 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5.0,
                      spreadRadius: 0.7,
                      offset: Offset(0.7, 0.7))
                ],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(AppLocalizations.of(context)!.driverLicense),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await getImage(
                                  ImageSource.camera, context, 'driverLis');
                            },
                            icon: const Icon(Icons.add_a_photo_outlined,
                                size: 35.0, color: Color(0xFFFBC408))),
                        IconButton(
                            onPressed: () async {
                              await getImage(
                                  ImageSource.gallery, context, 'driverLis');
                            },
                            icon: const Icon(Icons.image,
                                size: 35.0, color: Color(0xFFFBC408))),
                        showIconDriverLisImage(context, driverLis)
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              height: MediaQuery.of(context).size.height * 10 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5.0,
                      spreadRadius: 0.7,
                      offset: Offset(0.7, 0.7))
                ],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(AppLocalizations.of(context)!.carLicense),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await getImage(
                                  ImageSource.camera, context, 'carLis');
                            },
                            icon: const Icon(Icons.add_a_photo_outlined,
                                size: 35.0, color: Color(0xFFFBC408))),
                        IconButton(
                            onPressed: () async {
                              await getImage(
                                  ImageSource.gallery, context, 'carLis');
                            },
                            icon: const Icon(Icons.image,
                                size: 35.0, color: Color(0xFFFBC408))),
                        showIconCarLisImage(context, carLisImage)
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              height: MediaQuery.of(context).size.height * 10 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5.0,
                      spreadRadius: 0.7,
                      offset: Offset(0.7, 0.7))
                ],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.carImage,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await getImage(
                                  ImageSource.camera, context, 'carImage');
                            },
                            icon: const Icon(Icons.add_a_photo_outlined,
                                size: 35.0, color: Color(0xFFFBC408))),
                        IconButton(
                            onPressed: () async {
                              await getImage(
                                  ImageSource.gallery, context, 'carImage');
                            },
                            icon: const Icon(Icons.image,
                                size: 35.0, color: Color(0xFFFBC408))),
                        showIconCarisImage(context, carImage)
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 25.0),
            GestureDetector(
              onTap: () {
                if (driverImage == null) {
                  Tools().toastMsg(AppLocalizations.of(context)!.imageDrequired,
                      Colors.redAccent.shade700);
                } else if (driverLis == null) {
                  Tools().toastMsg(
                      AppLocalizations.of(context)!.licenseDrequired,
                      Colors.redAccent.shade700);
                } else if (carLisImage == null) {
                  Tools().toastMsg(
                      AppLocalizations.of(context)!.licenseCrequired,
                      Colors.redAccent.shade700);
                } else if (carImage == null) {
                  Tools().toastMsg(AppLocalizations.of(context)!.imageCrequired,
                      Colors.redAccent.shade700);
                } else {
                  Provider.of<BottomSheetValue>(context, listen: false)
                      .updateValue(-700.0);
                  Provider.of<DriverInfoInductor>(context, listen: false)
                      .updateState(true);

                  ///from here the main logic !!
                  storage1(
                      driverImage,
                      driverLis,
                      carLisImage,
                      carImage,
                      name,
                      lastName,
                      idNo,
                      carBrand,
                      carColor,
                      carModel,
                      dropBottomValue,
                      context,
                      result);
                }
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
                  AppLocalizations.of(context)!.confirm,
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
    );
  }

  Future<void> getImage(
      ImageSource source, BuildContext context, String status) async {
    try {
      XFile? _file = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 100,
      );
      if (_file == null) return;
      switch (status) {
        case 'driverImage':
          Provider.of<GetImageProvider>(context, listen: false)
              .updatePersonImage(_file);
          break;
        case 'driverLis':
          Provider.of<GetImageProvider>(context, listen: false)
              .updateImageDriverLis(_file);
          break;
        case 'carLis':
          Provider.of<GetImageProvider>(context, listen: false)
              .updateImageCarLis(_file);
          break;
        case 'carImage':
          Provider.of<GetImageProvider>(context, listen: false)
              .updateImagePlatLis(_file);
          break;
        default:
          null;
          break;
      }
    } on PlatformException catch (ex) {
      Tools().toastMsg(AppLocalizations.of(context)!.errorImage, Colors.red);
    }
  }

  showIconDriverImage(BuildContext context, XFile? driverImage) {
    if (driverImage != null) {
      // return Center(
      //     child: Lottie.asset('images/72470-right-sign.json',
      //         height: 40, width: 40));
      return Image.file(
        File(driverImage.path),
        width: 30,
        height: 30,
      );
    } else {
      return const Text("");
    }
  }

  showIconDriverLisImage(BuildContext context, XFile? driverLis) {
    if (driverLis != null) {
      // return Center(
      //     child: Lottie.asset('images/72470-right-sign.json',
      //         height: 40, width: 40));
      return Image.file(File(driverLis.path), width: 30, height: 30);
    } else {
      return const Text("");
    }
  }

  showIconCarLisImage(BuildContext context, XFile? carLisImage) {
    if (carLisImage != null) {
      return Image.file(File(carLisImage.path), width: 30, height: 30);
      // return Center(
      //     child: Lottie.asset('images/72470-right-sign.json',
      //         height: 40, width: 40));
    } else {
      return const Text("");
    }
  }

  showIconCarisImage(BuildContext context, XFile? carImage) {
    if (carImage != null) {
      // return Center(
      //     child: Lottie.asset('images/72470-right-sign.json',
      //         height: 40, width: 40));
      return Image.file(File(carImage.path), width: 30, height: 30);
    } else {
      return const Text("");
    }
  }

  void storage1(
      XFile? driverImage,
      XFile? driverLis,
      XFile? carLisImage,
      XFile? carImage,
      TextEditingController name,
      TextEditingController lastName,
      TextEditingController idNo,
      TextEditingController carBrand,
      TextEditingController carColor,
      TextEditingController carModel,
      String dropBottomValue,
      BuildContext context,
      String result) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('driver/${currentUser!.uid}')
        .child(path.basename(driverImage!.path));
    await ref.putFile(File(driverImage.path));
    String url1 = await ref.getDownloadURL();
    setToStorage2(url1, driverLis, carImage, carLisImage, name, lastName, idNo,
        carBrand, carModel, carColor, dropBottomValue, context, result);
  }

  void setToStorage2(
      String url1,
      XFile? driverLis,
      XFile? carImage,
      XFile? carLisImage,
      TextEditingController name,
      TextEditingController lastName,
      TextEditingController idNo,
      TextEditingController carBrand,
      TextEditingController carModel,
      TextEditingController carColor,
      String dropBottomValue,
      BuildContext context,
      String result) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('driver/${currentUser!.uid}')
        .child(path.basename(driverLis!.path));
    await ref.putFile(File(driverLis.path));
    String url2 = await ref.getDownloadURL();
    setFromToStorage3(url1, url2, carLisImage, carImage, name, lastName, idNo,
        carBrand, carModel, carColor, dropBottomValue, context, result);
  }

  void setFromToStorage3(
      String url1,
      String url2,
      XFile? carLisImage,
      XFile? carImage,
      TextEditingController name,
      TextEditingController lastName,
      TextEditingController idNo,
      TextEditingController carBrand,
      TextEditingController carModel,
      TextEditingController carColor,
      String dropBottomValue,
      BuildContext context,
      String result) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('driver/${currentUser!.uid}')
        .child(path.basename(carLisImage!.path));
    await ref.putFile(File(carLisImage.path));
    String url3 = await ref.getDownloadURL();
    storgeFrom3To4(url1, url2, url3, carImage, name, lastName, idNo, carBrand,
        carModel, carColor, dropBottomValue, context, result);
  }

  void storgeFrom3To4(
      String url1,
      String url2,
      String url3,
      XFile? carImage,
      TextEditingController name,
      TextEditingController lastName,
      TextEditingController idNo,
      TextEditingController carBrand,
      TextEditingController carModel,
      TextEditingController carColor,
      String dropBottomValue,
      BuildContext context,
      String result) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('driver/${currentUser!.uid}')
        .child(path.basename(carImage!.path));
    await ref.putFile(File(carImage.path));
    String url4 = await ref.getDownloadURL();
    setToRealTimeDataBase(url1, url2, url3, url4, name, lastName, idNo,
        carBrand, carModel, carColor, dropBottomValue, context, result);
  }

  void setToRealTimeDataBase(
      String url1,
      String url2,
      String url3,
      String url4,
      TextEditingController name,
      TextEditingController lastName,
      TextEditingController idNo,
      TextEditingController carBrand,
      TextEditingController carModel,
      TextEditingController carColor,
      String dropBottomValue,
      BuildContext context,
      String result) async {
    if (currentUser!.uid.isNotEmpty) {
      DatabaseReference driverRef = FirebaseDatabase.instance
          .ref()
          .child("driver")
          .child(currentUser!.uid);
      await driverRef.update({
        "userId": currentUser!.uid,
        "status": "checkIn",
        "exPlan": 0,
        "phoneNumber": result.toString(),
        "firstName": name.text,
        "lastName": lastName.text,
        "idNo": idNo.text.trim(),
        "personImage": url1.toString(),
        "driverLis": url2.toString(),
        "carLis": url3.toString(),
      }).whenComplete(() async {
        await driverRef.child("carInfo").update({
          "carBrand": carBrand.text,
          "carColor": carColor.text,
          "carModel": carModel.text,
          "carType": dropBottomValue.toString(),
          "carImage": url4.toString(),
        });
      }).whenComplete(() async {
        await getToken();
        Provider.of<DriverInfoInductor>(context, listen: false)
            .updateState(false);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const CheckInScreen()));
      });
    }
  }
}
