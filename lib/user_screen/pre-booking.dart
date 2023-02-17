import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../my_provider/bottom_sheet_preBook.dart';
import '../my_provider/driverInfo_inductor.dart';
import '../widget/bottom_sheet_perbooking.dart';
import '../widget/custom_circuler.dart';

class PreBooking extends StatefulWidget {
  const PreBooking({Key? key}) : super(key: key);
  @override
  State<PreBooking> createState() => _PreBookingState();
}

class _PreBookingState extends State<PreBooking>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double valSheet = Provider.of<BottomSheetProviderPreBooking>(context).val;
    final indector = Provider.of<DriverInfoInductor>(context).isTrue;
    _controller.forward();
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.reservation,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: const Color(0xFFFBC408),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'images/reservtion.jpeg',
                height: _height,
                width: _width,
                fit: BoxFit.cover,
                opacity: _animation,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 18.0, left: 6.0, right: 6.0),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.doReservation,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    color: const Color(0xFF00A3E0),
                    height: 1.0,
                    width: 160,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 6.0, right: 6.0),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.uploadImageReservation,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Provider.of<BottomSheetProviderPreBooking>(
                          context,
                          listen: false)
                      .updateState(0.0),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    margin: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFBC408),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      AppLocalizations.of(context)!.uploadImage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          AnimatedPositioned(
              right: 0.0,
              left: 0.0,
              bottom: valSheet,
              child:
                  CustomBottomSheetPreBooking().bottomSheetPreBooking(context),
              duration: const Duration(milliseconds: 600)),
          indector == true
              ? Opacity(
                  opacity: 0.9,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                    child: CircularInductorCostem()
                        .circularInductorCostem(context),
                  ),
                )
              : const Text("")
        ],
      ),
    ));
  }
}
