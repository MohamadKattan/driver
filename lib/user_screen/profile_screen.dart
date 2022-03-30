
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/driverInfo.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/indctor_profile_screen.dart';
import '../widget/custom_circuler.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static final TextEditingController name = TextEditingController();
  static final TextEditingController lastName = TextEditingController();
  static final TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final driverInfo = Provider.of<DriverInfoModelProvider>(context).driverInfo;
    bool isTrue =  Provider.of<InductorProfileProvider>(context).isTrue;
    return SafeArea(
      child: Scaffold(
        body:
        Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  showImage(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 15 / 100),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black, fontSize: 16.0),
                      controller: name,
                      maxLength: 40,
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.edit, size: 30.0),
                        hintText: driverInfo.firstName,
                        hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black, fontSize: 16.0),
                      controller: lastName,
                      maxLength: 40,
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.edit, size: 30.0),
                        hintText: driverInfo.lastName,
                        hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black, fontSize: 16.0),
                      controller: email,
                      maxLength: 40,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.edit, size: 30.0),
                        hintText: driverInfo.email,
                        hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: (){
                          Provider.of<InductorProfileProvider>(context,listen: false).updateState(true);
                          startUpdateInfoUser(
                              driverInfo, name, lastName, email,context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD54F),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        height: MediaQuery.of(context).size.height * 10 / 100,
                        width: MediaQuery.of(context).size.width * 80 / 100,
                        child: const Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isTrue==true?CircularInductorCostem().circularInductorCostem(context):const Text(""),
          ],
        ),
      ),
    );
  }


  Widget showImage(BuildContext context) {
    final userInfoRealTime =
        Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
    return userInfoRealTime.personImage.isNotEmpty
        ? CachedNetworkImage(
          imageBuilder: (context, imageProvider) => Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          imageUrl: userInfoRealTime.personImage,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.person),
        )
        : const CircleAvatar(
      radius: 30,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.person,
        color: Colors.black12,
        size: 35,
      ),
    );
  }


  Future<void> startUpdateInfoUser(
      DriverInfo userInfo,
      TextEditingController name,
      TextEditingController lastName,
      TextEditingController email,
      BuildContext context
      ) async {

    DatabaseReference ref =
    FirebaseDatabase.instance.ref().child("driver").child(userInfo.userId);
    await ref.update({
      "firstName": name.text.isEmpty?userInfo.firstName:name.text,
      "lastName": lastName.text.isEmpty?userInfo.lastName:lastName.text,
      "email": email.text.isEmpty?userInfo.email:email.text.trim(),
    }).whenComplete((){
      Provider.of<InductorProfileProvider>(context,listen: false).updateState(false);
    });
  }
}

