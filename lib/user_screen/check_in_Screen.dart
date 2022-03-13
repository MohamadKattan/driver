import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../my_provider/icon_phone_value.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phoneIconValue = Provider.of<PhoneIconValue>(context).IconValue;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Provider.of<PhoneIconValue>(context, listen: false)
                .updateValue(-100.0),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                          child: Lottie.asset(
                              'images/93505-recruiter-hiring.json',
                              height: 350,
                              width: 350)),
                    ),
                    const Center(
                      child: Text(
                        "We are checking information",
                        style: TextStyle(
                            fontSize: 30.0,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "we appreciate your waiting ",
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "We will send to you a Notification ",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: GestureDetector(
                          onTap: () => Provider.of<PhoneIconValue>(context,
                                  listen: false)
                              .updateValue(60.0),
                          child: const Text(
                            "More Info!",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Click",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
              right: 0.0,
              left: 0.0,
              bottom: phoneIconValue,
              child: IconButton(
                icon: const Icon(
                  Icons.phone_in_talk_rounded,
                  color: Colors.green,
                  size: 60,
                ),
                onPressed: () {},
              ),
              duration: const Duration(milliseconds: 300))
        ],
      ),
    ));
  }
}
