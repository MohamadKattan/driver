import 'package:country_list_pick/country_list_pick.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

GlobalKey globalKey = GlobalKey();

class DriverInfoScreen extends StatefulWidget {
  const DriverInfoScreen({Key? key}) : super(key: key);
  static final TextEditingController name = TextEditingController();
  static final TextEditingController lastName = TextEditingController();
  static final TextEditingController carBrand = TextEditingController();
  static final TextEditingController carModel = TextEditingController();
  static final TextEditingController carColor = TextEditingController();
  static final TextEditingController carPlat = TextEditingController();
  static final TextEditingController idNo = TextEditingController();
  static final TextEditingController phoneNumber = TextEditingController();

  @override
  State<DriverInfoScreen> createState() => _DriverInfoScreenState();
}

class _DriverInfoScreenState extends State<DriverInfoScreen> {
  static String result = "";
  static String? resultCodeCon = "+90";
  late String newVal = "Select a car class";
  @override
  Widget build(BuildContext context) {
    final dropBottomValue = Provider.of<DropBottomValue>(context).valDrop;
    final bottomSheetValue =
        Provider.of<BottomSheetValue>(context).bottomSheetValue;
    final indector = Provider.of<DriverInfoInductor>(context).isTrue;
    return WillPopScope(
      onWillPop: () async => false,
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
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(AppLocalizations.of(context)!.driverInfo,
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD54F)))),
                      CustomTextField().customTextField(
                        lenNumber: 11,
                          controller: DriverInfoScreen.name,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.yourName,
                            hintStyle: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                            contentPadding: const EdgeInsets.all(8.0),
                          )),
                      CustomTextField().customTextField(
                        lenNumber: 11,
                          controller: DriverInfoScreen.lastName,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.lastName,
                            hintStyle: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                            contentPadding: const EdgeInsets.all(8.0),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CountryListPick(
                                  appBar: AppBar(
                                    backgroundColor: Colors.amber[200],
                                    title: Text(
                                        AppLocalizations.of(context)!.country),
                                  ),
                                  theme: CountryTheme(
                                    isShowFlag: true,
                                    isShowTitle: false,
                                    isShowCode: true,
                                    isDownIcon: true,
                                    showEnglishName: false,
                                    labelColor: Colors.black54,
                                    alphabetSelectedBackgroundColor:
                                        const Color(0xFFFFD54F),
                                    alphabetTextColor: Colors.deepOrange,
                                    alphabetSelectedTextColor:
                                        Colors.deepPurple,
                                  ),
                                  initialSelection: resultCodeCon,
                                  onChanged: (CountryCode? code) {
                                    resultCodeCon = code?.dialCode;
                                  },
                                  useUiOverlay: true,
                                  useSafeArea: false),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: DriverInfoScreen.phoneNumber,
                                maxLength: 15,
                                showCursor: true,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                                cursorColor: const Color(0xFFFFD54F),
                                decoration: InputDecoration(
                                  icon: const Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: Icon(
                                      Icons.phone,
                                      color: Color(0xFFFFD54F),
                                    ),
                                  ),
                                  fillColor: const Color(0xFFFFD54F),
                                  label: Text(AppLocalizations.of(context)!
                                      .phonenumber),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomTextField().customTextField(
                        lenNumber: 11,
                          controller: DriverInfoScreen.idNo,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.idNumber,
                            hintStyle: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                            contentPadding: const EdgeInsets.all(8.0),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(AppLocalizations.of(context)!.carDetails,
                            style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD54F))),
                      ),
                      CustomTextField().customTextField(
                        lenNumber: 30,
                        controller: DriverInfoScreen.carBrand,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.carBrand,
                          hintStyle: const TextStyle(
                              color: Colors.black54, fontSize: 16),
                          contentPadding: const EdgeInsets.all(8.0),
                        ),
                      ),
                      CustomTextField().customTextField(
                        lenNumber: 20,
                        controller: DriverInfoScreen.carModel,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.carModel,
                          hintStyle: const TextStyle(
                              color: Colors.black54, fontSize: 16),
                          contentPadding: const EdgeInsets.all(8.0),
                        ),
                      ),
                      CustomTextField().customTextField(
                        lenNumber: 20,
                        controller: DriverInfoScreen.carColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.carColor,
                            hintStyle: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                            contentPadding: const EdgeInsets.all(8.0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: dropBottomCustom(context, dropBottomValue),
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
                            height:
                                MediaQuery.of(context).size.height * 10 / 100,
                            width: MediaQuery.of(context).size.width * 80 / 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD54F),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.next,
                              style: const TextStyle(
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
                        DriverInfoScreen.name,
                        DriverInfoScreen.lastName,
                        DriverInfoScreen.idNo,
                        DriverInfoScreen.carBrand,
                        DriverInfoScreen.carColor,
                        DriverInfoScreen.carModel,
                        dropBottomValue,
                        result),
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
    if (DriverInfoScreen.name.text.isEmpty) {
      Tools().toastMsg(
          AppLocalizations.of(context)!.nameDriver, Colors.redAccent.shade700);
    } else if (DriverInfoScreen.lastName.text.isEmpty) {
      Tools().toastMsg(
          AppLocalizations.of(context)!.lastDriver, Colors.redAccent.shade700);
    } else if (DriverInfoScreen.phoneNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          content: Text(AppLocalizations.of(context)!.phoneempty),
        ),
      );
    } else if (DriverInfoScreen.idNo.text.isEmpty) {
      Tools().toastMsg(AppLocalizations.of(context)!.idCarRequired,
          Colors.redAccent.shade700);
    } else if (DriverInfoScreen.carBrand.text.isEmpty) {
      Tools().toastMsg(AppLocalizations.of(context)!.brandRequired,
          Colors.redAccent.shade700);
    } else if (DriverInfoScreen.carModel.text.isEmpty) {
      Tools().toastMsg(AppLocalizations.of(context)!.brandRequired,
          Colors.redAccent.shade700);
    } else if (DriverInfoScreen.carColor.text.isEmpty) {
      Tools().toastMsg(AppLocalizations.of(context)!.colorRequired,
          Colors.redAccent.shade700);
    } else if (dropBottomValue == "Select a car class") {
      Tools().toastMsg(AppLocalizations.of(context)!.classRequired,
          Colors.redAccent.shade700);
    } else {
      Provider.of<BottomSheetValue>(context, listen: false).updateValue(0.0);
      result = "$resultCodeCon${DriverInfoScreen.phoneNumber.text}";
    }
  }

  Widget dropBottomCustom(BuildContext context, String dropBottomProvider) {
    String? _value = "Select a car class";
    String? value1 = AppLocalizations.of(context)!.selectCar;
    return Padding(
      padding: const EdgeInsets.only(right: 4.0, left: 4.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        height: MediaQuery.of(context).size.height * 6 / 100,
        width: MediaQuery.of(context).size.width * 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: const Color(0xFFFFD54F), width: 2)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
              value: newVal == "Select a car class" ? value1 : newVal,
              isExpanded: true,
              dropdownColor: Colors.white,
              iconSize: 40.0,
              items: <String>[
                AppLocalizations.of(context)!.selectCar,
                AppLocalizations.of(context)!.taxi,
                AppLocalizations.of(context)!.veto,
                AppLocalizations.of(context)!.van,
                'Free Emergency Ambulance',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) {
                if (val == "Taxi-4 seats" ||
                    val == "Taksi-4 koltuk" ||
                    val == "تاكسي - 4 مقاعد" && _value != null) {
                  setState(() {
                    _value = "Taxi-4 seats";
                    Provider.of<DropBottomValue>(context, listen: false)
                        .updateValue("Taxi-4 seats");
                    newVal = AppLocalizations.of(context)!.taxi;
                  });
                } else if (val == "Medium commercial-6-10 seats" ||
                    val == "Orta boy ticari-6-10 koltuk arası" ||
                    val == "متوسط تجاري - ٦-١٠ مقاعد" && _value != null) {
                  setState(() {
                    _value = "Medium commercial-6-10 seats";
                    Provider.of<DropBottomValue>(context, listen: false)
                        .updateValue("Medium commercial-6-10 seats");
                    newVal = AppLocalizations.of(context)!.veto;
                  });
                } else if (val == "Big commercial-11-19 seats" ||
                    val == "Büyük ticari 11-19 koltuk arası" ||
                    val == "تجاري كبير - ١١-١٩ مقعدا" && _value != null) {
                  setState(() {
                    _value = "Big commercial-11-19 seats";
                    Provider.of<DropBottomValue>(context, listen: false)
                        .updateValue("Big commercial-11-19 seats");
                    newVal = AppLocalizations.of(context)!.van;
                  });
                } else {
                  return;
                }
              }),
        ),
      ),
    );
  }
}
