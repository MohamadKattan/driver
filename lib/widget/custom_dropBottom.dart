// dropBottomCustom  using  in driverInfo screen
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../my_provider/dropBottom_value_provider.dart';
//
// class CustomDropBottom {
//   String? value = "Select a car class";
//
//   Widget dropBottomCustom(BuildContext context, String dropBottomProvider) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 4.0, left: 4.0),
//       child: Container(
//         padding: const EdgeInsets.all(4.0),
//         height: MediaQuery.of(context).size.height * 6 / 100,
//         width: MediaQuery.of(context).size.width * 100,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4.0),
//             border: Border.all(color: const Color(0xFFFFD54F), width: 2)),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//               value: dropBottomProvider,
//               isExpanded: true,
//               dropdownColor: Colors.white,
//               iconSize: 40.0,
//               items: <String>[
//                 'Select a car class',
//                 'Taxi-4 seats',
//                 'Medium commercial-6-10 seats',
//                 'Big commercial-11-19 seats',
//                 'Free Emergency Ambulance',
//               ].map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (val) {
//                 if (value != null) {
//                   value = val;
//                   Provider.of<DropBottomValue>(context, listen: false)
//                       .updateValue(value!);
//                 } else {
//                   return;
//                 }
//               }),
//         ),
//       ),
//     );
//   }
// }
