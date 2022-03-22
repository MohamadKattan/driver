// this class for custom bottom sheet use in DriverInfoScreen

import 'dart:io';
import 'package:driver/tools/tools.dart';
import 'package:driver/user_screen/check_in_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../my_provider/bottom_sheet_value.dart';
import '../my_provider/driverInfo_inductor.dart';
import '../my_provider/get_image_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:firebase_database/firebase_database.dart';

import '../repo/auth_srv.dart';

class CustomBottomSheet {
  final ImagePicker _picker = ImagePicker();
  late XFile? image1;
  late final XFile? image2;
  late final XFile? image3;
  late final XFile? image4;
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
          color: Colors.white,
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
                        .updateValue(-600.0),
                icon: const Icon(
                  Icons.remove,
                  size: 35.0,
                  color: Colors.black45,
                )),
            const Center(
                child: Text("Pick some images to approve your details")),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Personnel image"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              image1 = await _picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 30,
                                  maxHeight: 120.0,
                                  maxWidth: 120.0);
                              Provider.of<GetImageProvider>(context,
                                      listen: false)
                                  .updatePersonImage(image1!);
                            },
                            icon: const Icon(Icons.add_a_photo_outlined,
                                size: 35.0, color: Color(0xFFFFD54F))),
                        IconButton(
                            onPressed: () async {
                              image1 = await _picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 30,
                                maxWidth: 120,
                                maxHeight: 120,
                              );
                              Provider.of<GetImageProvider>(context,
                                      listen: false)
                                  .updatePersonImage(image1!);
                            },
                            icon: const Icon(Icons.image,
                                size: 35.0, color: Color(0xFFFFD54F))),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Driver license"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              image2 = await _picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 30,
                                  maxHeight: 120.0,
                                  maxWidth: 120.0);
                              Provider.of<GetImageProvider>(context,
                                      listen: false)
                                  .updateImageDriverLis(image2!);
                            },
                            icon: const Icon(Icons.add_a_photo_outlined,
                                size: 35.0, color: Color(0xFFFFD54F))),
                        IconButton(
                            onPressed: () async {
                              image2 = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 30,
                                  maxHeight: 120.0,
                                  maxWidth: 120.0);
                              Provider.of<GetImageProvider>(context,
                                      listen: false)
                                  .updateImageDriverLis(image2!);
                            },
                            icon: const Icon(Icons.image,
                                size: 35.0, color: Color(0xFFFFD54F))),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Car license"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              image3 = await _picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 30,
                                  maxHeight: 120.0,
                                  maxWidth: 120.0);
                              Provider.of<GetImageProvider>(context,
                                      listen: false)
                                  .updateImageCarLis(image3!);
                            },
                            icon: const Icon(Icons.add_a_photo_outlined,
                                size: 35.0, color: Color(0xFFFFD54F))),
                        IconButton(
                            onPressed: () async {
                              image3 = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 30,
                                  maxHeight: 120.0,
                                  maxWidth: 120.0);
                              Provider.of<GetImageProvider>(context,
                                      listen: false)
                                  .updateImageCarLis(image3!);
                            },
                            icon: const Icon(Icons.image,
                                size: 35.0, color: Color(0xFFFFD54F))),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Car image"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              image4 = await _picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 30,
                                  maxHeight: 120.0,
                                  maxWidth: 120.0);
                              Provider.of<GetImageProvider>(context,
                                      listen: false)
                                  .updateImagePlatLis(image4!);
                            },
                            icon: const Icon(Icons.add_a_photo_outlined,
                                size: 35.0, color: Color(0xFFFFD54F))),
                        IconButton(
                            onPressed: () async {
                              image4 = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 30,
                                  maxHeight: 120.0,
                                  maxWidth: 120.0);
                              Provider.of<GetImageProvider>(context,
                                      listen: false)
                                  .updateImagePlatLis(image4!);
                            },
                            icon: const Icon(Icons.image,
                                size: 35.0, color: Color(0xFFFFD54F))),
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
                  Tools().toastMsg("Driver Image is required");
                } else if (driverLis == null) {
                  Tools().toastMsg("Driver license is required");
                } else if (carLisImage == null) {
                  Tools().toastMsg("Car license is required");
                } else if (carImage == null) {
                  Tools().toastMsg("Car Image is required");
                } else {
                  Provider.of<BottomSheetValue>(context, listen: false)
                      .updateValue(-600.0);
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
                      context);
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 8 / 100,
                width: MediaQuery.of(context).size.width * 60 / 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Center(child: Text("Confirm")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showIconDriverImage(BuildContext context, XFile? driverImage) {
    if (driverImage != null) {
      return Center(
          child: Lottie.asset('images/72470-right-sign.json',
              height: 40, width: 40));
    } else {
      return const Text("");
    }
  }

  showIconDriverLisImage(BuildContext context, XFile? driverLis) {
    if (driverLis != null) {
      return Center(
          child: Lottie.asset('images/72470-right-sign.json',
              height: 40, width: 40));
    } else {
      return const Text("");
    }
  }

  showIconCarLisImage(BuildContext context, XFile? carLisImage) {
    if (carLisImage != null) {
      return Center(
          child: Lottie.asset('images/72470-right-sign.json',
              height: 40, width: 40));
    } else {
      return const Text("");
    }
  }

  showIconCarisImage(BuildContext context, XFile? carImage) {
    if (carImage != null) {
      return Center(
          child: Lottie.asset('images/72470-right-sign.json',
              height: 40, width: 40));
    } else {
      return const Text("");
    }
  }

  /// this method canceled for now
  // setToDataBase(
  //      List<XFile> imagesL,
  //      TextEditingController name,
  //      TextEditingController lastName,
  //      TextEditingController idNo,
  //      TextEditingController email,
  //      TextEditingController carBrand,
  //      TextEditingController carColor,
  //      TextEditingController carModel,
  //      String dropBottomValue) async {
  //    User? currentUser = AuthSev().auth.currentUser;
  //
  //
  //    ///first set image to Storage and got url
  //    for (var _image in imagesL) {
  //      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //          .ref()
  //          .child('driver/${currentUser!.uid}')
  //          .child(path.basename(_image.path));
  //           await ref.putFile(File(_image.path)).whenComplete(()async{
  //           String url  = await ref.getDownloadURL();
  //
  //            if (currentUser.uid.isNotEmpty) {
  //              DatabaseReference driverRef = FirebaseDatabase.instance
  //                  .ref()
  //                  .child("driver")
  //                  .child(currentUser.uid);
  //              driverRef.set({
  //                "userId": currentUser.uid,
  //                "phoneNumber": currentUser.phoneNumber,
  //                "firstName": name.text,
  //                "lastName": lastName.text,
  //                "idNo": idNo.text.trim(),
  //                "email": email.text.trim(),
  //                // "driverLis": url.toString(),
  //                // "carLis": urlRef.toString(),
  //                // "carImage": urlRef.toString(),
  //              }).whenComplete(() async {
  //                await driverRef.child("carInfo").set({
  //                  "carBrand": carBrand.text,
  //                  "carColor": carColor.text,
  //                  "carModel": carModel.text,
  //                  "carType": dropBottomValue.toString(),
  //                  // "carImage": urlRef.toString()
  //                });
  //              });
  //            }
  //           });
  //    }
  //  }

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
      BuildContext context) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('driver/${currentUser!.uid}')
        .child(path.basename(driverImage!.path));
    await ref.putFile(File(driverImage.path));
    String url1 = await ref.getDownloadURL();
    setToStorage2(url1, driverLis, carImage, carLisImage, name, lastName, idNo,
         carBrand, carModel, carColor, dropBottomValue, context);
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
      BuildContext context) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('driver/${currentUser!.uid}')
        .child(path.basename(driverLis!.path));
    await ref.putFile(File(driverLis.path));
    String url2 = await ref.getDownloadURL();
    setFromToStorage3(url1, url2, carLisImage, carImage, name, lastName, idNo,
        carBrand, carModel, carColor, dropBottomValue, context);
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
      BuildContext context) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('driver/${currentUser!.uid}')
        .child(path.basename(carLisImage!.path));
    await ref.putFile(File(carLisImage.path));
    String url3 = await ref.getDownloadURL();
    storgeFrom3To4(url1, url2, url3, carImage, name, lastName, idNo,
        carBrand, carModel, carColor, dropBottomValue, context);
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
      BuildContext context) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('driver/${currentUser!.uid}')
        .child(path.basename(carImage!.path));
    await ref.putFile(File(carImage.path));
    String url4 = await ref.getDownloadURL();
    setToRealTimeDataBase(url1, url2, url3, url4, name, lastName, idNo,
        carBrand, carModel, carColor, dropBottomValue, context);
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
      BuildContext context) async {
    if (currentUser!.uid.isNotEmpty) {
      DatabaseReference driverRef = FirebaseDatabase.instance
          .ref()
          .child("driver")
          .child(currentUser!.uid);
      await driverRef.update({
        "userId": currentUser!.uid,
        "status": "checkIn",
        "firstName": name.text,
        "lastName": lastName.text,
        "idNo": idNo.text.trim(),
        "personImage": url1.toString(),
        "driverLis": url2.toString(),
        "carLis": url3.toString(),
      }).whenComplete(() async {
        await driverRef.child("carInfo").set({
          "carBrand": carBrand.text,
          "carColor": carColor.text,
          "carModel": carModel.text,
          "carType": dropBottomValue.toString(),
          "carImage": url4.toString(),
        });
      }).whenComplete(() {
        Provider.of<DriverInfoInductor>(context, listen: false)
            .updateState(false);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CheckInScreen()),
            (route) => false);
      });
    }
  }
}
