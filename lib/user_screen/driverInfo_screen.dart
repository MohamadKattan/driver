import 'package:driver/tools/tools.dart';
import 'package:driver/widget/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../my_provider/bottom_sheet_value.dart';
import '../my_provider/driverInfo_inductor.dart';
import '../my_provider/dropBottom_value_provider.dart';
import '../widget/custom_TextField.dart';
import '../widget/custom_circuler.dart';
import '../widget/custom_dropBottom.dart';

class DriverInfoScreen extends StatelessWidget {
  const DriverInfoScreen({Key? key}) : super(key: key);
  static final TextEditingController name = TextEditingController();
  static final TextEditingController lastName = TextEditingController();
  static final TextEditingController carBrand = TextEditingController();
  static final TextEditingController carModel = TextEditingController();
  static final TextEditingController carColor = TextEditingController();
  static final TextEditingController carPlat = TextEditingController();
  static final TextEditingController idNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dropBottomValue = Provider.of<DropBottomValue>(context).valDrop;
    final bottomSheetValue =
        Provider.of<BottomSheetValue>(context).bottomSheetValue;
    final indector = Provider.of<DriverInfoInductor>(context).isTrue;
    return WillPopScope(
      onWillPop: ()async=> false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                            child: Lottie.asset(
                                'images/43886-checking-and-scanning.json',
                                height: 150,
                                width: 150)),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Driver Info",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD54F)))),
                      CustomTextField().customTextField(
                          controller: name,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: "Your Name",
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 16),
                            contentPadding: EdgeInsets.all(8.0),
                          )),
                      CustomTextField().customTextField(
                          controller: lastName,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: "Last Name",
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 16),
                            contentPadding: EdgeInsets.all(8.0),
                          )),
                      CustomTextField().customTextField(
                          controller: idNo,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Id Number",
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 16),
                            contentPadding: EdgeInsets.all(8.0),
                          )),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Car Details",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD54F))),
                      ),
                      CustomTextField().customTextField(
                        controller: carBrand,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: "Car Brand",
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 16),
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                      CustomTextField().customTextField(
                        controller: carModel,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: "Car Model",
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 16),
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                      CustomTextField().customTextField(
                        controller: carColor,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            hintText: "Car Color",
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 16),
                            contentPadding: EdgeInsets.all(8.0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CustomDropBottom()
                            .dropBottomCustom(context, dropBottomValue),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => checkIfTextFieldNotNull(
                              bottomSheetValue, dropBottomValue, context),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 10 / 100,
                            width: MediaQuery.of(context).size.width * 80 / 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD54F),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: const Center(
                                child: Text(
                              "Next",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedPositioned(
                    right: 0.0,
                    left: 0.0,
                    bottom: bottomSheetValue,
                    child: CustomBottomSheet().customBottomSheet(
                        context,
                        bottomSheetValue,
                        name,
                        lastName,
                        idNo,
                        carBrand,
                        carColor,
                        carModel,
                        dropBottomValue),
                    duration: const Duration(milliseconds: 600)),
                indector == true
                    ? CircularInductorCostem().circularInductorCostem(context)
                    : const Text("")
              ],
            ),
          ),
        ),
      ),
    );
  }

// this method for check if not null TextField to change bottomSheetValue for pick images
  checkIfTextFieldNotNull(
      double bottomSheetValue, String dropBottomValue, BuildContext context) {
    if (name.text.isEmpty) {
      Tools().toastMsg("Name driver is required");
    } else if (lastName.text.isEmpty) {
      Tools().toastMsg("last name driver is required");
    } else if (idNo.text.isEmpty) {
      Tools().toastMsg("Id Card number is required");
    } else if (carBrand.text.isEmpty) {
      Tools().toastMsg("Car brand  is required");
    } else if (carModel.text.isEmpty) {
      Tools().toastMsg("Car model  is required");
    } else if (carColor.text.isEmpty) {
      Tools().toastMsg("Car color  is required");
    } else if (dropBottomValue == "Select a car class") {
      Tools().toastMsg("car class  is required");
    } else {
      Provider.of<BottomSheetValue>(context, listen: false).updateValue(0.0);
    }
  }
}
