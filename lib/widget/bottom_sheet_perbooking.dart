// this class for custom bottom sheet use in per booking
import 'dart:io';
import 'package:driver/tools/tools.dart';
import 'package:driver/widget/perBookDialogOk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../my_provider/bottom_sheet_preBook.dart';
import '../my_provider/driverInfo_inductor.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:firebase_database/firebase_database.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/preBook_imagePro.dart';
import '../repo/auth_srv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomSheetPreBooking {
  final ImagePicker _picker = ImagePicker();
  late final XFile? image1;
  late final XFile? image2;
  late final XFile? image3;
  User? currentUser = AuthSev().auth.currentUser;
  Widget bottomSheetPreBooking(
    BuildContext context,
  ) {
    final carInside = Provider.of<GetImagePreBook>(context).carInside;
    final carOutSide = Provider.of<GetImagePreBook>(context).carOutSide;
    final carOutSide1 = Provider.of<GetImagePreBook>(context).carOutSide1;
    return Container(
      height: MediaQuery.of(context).size.height * 65 / 100,
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
                onPressed: () => Provider.of<BottomSheetProviderPreBooking>(
                        context,
                        listen: false)
                    .updateState(-700.0),
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
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(AppLocalizations.of(context)!.carInside,
                          textAlign: TextAlign.center),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 0,
                            child: IconButton(
                                onPressed: () async {
                                  image1 = await _picker.pickImage(
                                    source: ImageSource.camera,
                                    maxWidth: 500,
                                    maxHeight: 500,
                                    imageQuality: 100,
                                  );
                                  Provider.of<GetImagePreBook>(context,
                                          listen: false)
                                      .updateCarInside(image1!);
                                },
                                icon: const Icon(Icons.add_a_photo_outlined,
                                    size: 35.0, color: Color(0xFFFBC408))),
                          ),
                          Expanded(
                            flex: 0,
                            child: IconButton(
                                onPressed: () async {
                                  image1 = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                    maxWidth: 500,
                                    maxHeight: 500,
                                    imageQuality: 100,
                                  );
                                  Provider.of<GetImagePreBook>(context,
                                          listen: false)
                                      .updateCarInside(image1!);
                                },
                                icon: const Icon(Icons.image,
                                    size: 35.0, color: Color(0xFFFBC408))),
                          ),
                          showIconInsideCar(context, carInside)
                        ],
                      ),
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
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!.carOutside,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                image2 = await _picker.pickImage(
                                  source: ImageSource.camera,
                                  maxWidth: 500,
                                  maxHeight: 500,
                                  imageQuality: 100,
                                );
                                Provider.of<GetImagePreBook>(context,
                                        listen: false)
                                    .updateCarOutSide(image2!);
                              },
                              icon: const Icon(Icons.add_a_photo_outlined,
                                  size: 35.0, color: Color(0xFFFBC408))),
                          IconButton(
                              onPressed: () async {
                                image2 = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  maxWidth: 500,
                                  maxHeight: 500,
                                  imageQuality: 100,
                                );
                                Provider.of<GetImagePreBook>(context,
                                        listen: false)
                                    .updateCarOutSide(image2!);
                              },
                              icon: const Icon(Icons.image,
                                  size: 35.0, color: Color(0xFFFBC408))),
                          showIconCarOutSide(context, carOutSide)
                        ],
                      ),
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
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!.carOutside1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                image3 = await _picker.pickImage(
                                  source: ImageSource.camera,
                                  maxWidth: 500,
                                  maxHeight: 500,
                                  imageQuality: 100,
                                );
                                Provider.of<GetImagePreBook>(context,
                                        listen: false)
                                    .updateCarOutSide1(image3!);
                              },
                              icon: const Icon(Icons.add_a_photo_outlined,
                                  size: 35.0, color: Color(0xFFFBC408))),
                          IconButton(
                              onPressed: () async {
                                image3 = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  maxWidth: 500,
                                  maxHeight: 500,
                                  imageQuality: 100,
                                );
                                Provider.of<GetImagePreBook>(context,
                                        listen: false)
                                    .updateCarOutSide1(image3!);
                              },
                              icon: const Icon(Icons.image,
                                  size: 35.0, color: Color(0xFFFBC408))),
                          showIconCarOutSide1(context, carOutSide1)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 25.0),
            GestureDetector(
              onTap: () {
                if (carInside == null) {
                  Tools().toastMsg(AppLocalizations.of(context)!.carInsideReq,
                      Colors.redAccent.shade700);
                } else if (carOutSide == null) {
                  Tools().toastMsg(AppLocalizations.of(context)!.carOutSideReq,
                      Colors.redAccent.shade700);
                } else if (carOutSide1 == null) {
                  Tools().toastMsg(AppLocalizations.of(context)!.carOutside1Req,
                      Colors.redAccent.shade700);
                } else {
                  Provider.of<BottomSheetProviderPreBooking>(context,
                          listen: false)
                      .updateState(-700.0);
                  Provider.of<DriverInfoInductor>(context, listen: false)
                      .updateState(true);

                  ///from here the main logic !!
                  storage1(carInside, carOutSide, carOutSide1, context);
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

  showIconInsideCar(BuildContext context, XFile? carInside) {
    if (carInside != null) {
      return Expanded(
        flex: 0,
        child: Center(
            child: Lottie.asset('images/72470-right-sign.json',
                height: 40, width: 40)),
      );
    } else {
      return const Expanded(flex: 0, child: Text(""));
    }
  }

  showIconCarOutSide(BuildContext context, XFile? carOutSide) {
    if (carOutSide != null) {
      return Center(
          child: Lottie.asset('images/72470-right-sign.json',
              height: 40, width: 40));
    } else {
      return const Text("");
    }
  }

  showIconCarOutSide1(BuildContext context, XFile? carOutSide1) {
    if (carOutSide1 != null) {
      return Center(
          child: Lottie.asset('images/72470-right-sign.json',
              height: 40, width: 40));
    } else {
      return const Text("");
    }
  }

  void storage1(XFile? carInside, XFile? carOutSide, XFile? carOutSide1,
      BuildContext context) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('prebook/${currentUser!.uid}')
        .child(path.basename(carInside!.path));
    await ref.putFile(File(carInside.path));
    String url1 = await ref.getDownloadURL();
    setToStorage2(url1, carOutSide, carOutSide1, context);
  }

  void setToStorage2(String url1, XFile? carOutSide, XFile? carOutSide1,
      BuildContext context) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('prebook/${currentUser!.uid}')
        .child(path.basename(carOutSide!.path));
    await ref.putFile(File(carOutSide.path));
    String url2 = await ref.getDownloadURL();
    setFromToStorage3(url1, url2, carOutSide1, context);
  }

  void setFromToStorage3(String url1, String url2, XFile? carOutSide1,
      BuildContext context) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('prebook/${currentUser!.uid}')
        .child(path.basename(carOutSide1!.path));
    await ref.putFile(File(carOutSide1.path));
    String url3 = await ref.getDownloadURL();
    setToRealTimeDataBase(url1, url2, url3, context);
  }

  void setToRealTimeDataBase(
      String url1, String url2, String url3, BuildContext context) async {
    final _driverInfo =
        Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
    if (currentUser!.uid.isNotEmpty) {
      DatabaseReference preBookRef = FirebaseDatabase.instance
          .ref()
          .child("prebook")
          .child(currentUser!.uid);
      await preBookRef.set({
        "userId": currentUser!.uid,
        "phoneNumber": _driverInfo.phoneNumber,
        "country": _driverInfo.country,
        "city": _driverInfo.city,
        "firstName": _driverInfo.firstName,
        "lastName": _driverInfo.lastName,
        "idNo": _driverInfo.idNo,
        "carBrand": _driverInfo.carBrand,
        "carColor": _driverInfo.carColor,
        "carModel": _driverInfo.carModel,
        "carType": _driverInfo.carType,
        "driverImage": _driverInfo.personImage,
        "carInside": url1.toString(),
        "carOutSide": url2.toString(),
        "carOutSide1": url3.toString(),
      }).whenComplete(() async {
        Provider.of<DriverInfoInductor>(context, listen: false)
            .updateState(false);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => preBookOkay(context));
      });
    }
  }
}
