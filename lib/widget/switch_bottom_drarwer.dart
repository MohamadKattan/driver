import 'package:flutter/material.dart';
import '../config.dart';
import '../notificatons/push_notifications_srv.dart';

class SwitchBottomDrawer extends StatefulWidget {
  const SwitchBottomDrawer({Key? key}) : super(key: key);

  @override
  State<SwitchBottomDrawer> createState() => _SwitchBottomDrawerState();
}

class _SwitchBottomDrawerState extends State<SwitchBottomDrawer> {
  bool valueBottom = true;
  @override
  void initState() {
    gotValueBottom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: SizedBox(
        width: 60.0,
        child: Switch.adaptive(
          activeColor: Colors.green,
          activeTrackColor: Colors.green.shade200,
          inactiveThumbColor: Colors.redAccent.shade700,
          inactiveTrackColor: Colors.redAccent.shade200,
          value: valueBottom,
          splashRadius: 30.0,
          onChanged: (val) {
            setState(() {
              valueBottom = val;
            });
            if (valueBottom == true) {
              driverRef.child(userId).child("card").set("foundCard");
            } else if (valueBottom == false) {
              driverRef.child(userId).child("card").set("NoCard");
            }
          },
        ),
      ),
    );
  }

  gotValueBottom() {
    driverRef.child(userId).child("card").once().then((value) {
      if (value.snapshot.value != null) {
        String _card = value.snapshot.value.toString();
        if (_card == "foundCard") {
          setState(() {
            valueBottom = true;
          });
        } else {
          setState(() {
            valueBottom = false;
          });
        }
      }
    });
  }
}
