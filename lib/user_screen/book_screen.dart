
import 'package:driver/model/trip_history.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../repo/auth_srv.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);


  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final currentUser = AuthSev().auth.currentUser;
  late DatabaseReference ref;
  @override
  void initState() {
     ref = FirebaseDatabase.instance.ref().child("driver")
        .child(currentUser!.uid)
        .child("history");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: ()=>clearHistory(), icon:const Icon(Icons.delete),)],
        backgroundColor: const Color(0xFFFFD54F),
        automaticallyImplyLeading: false,
        title: const Text("My Booking",
            style: TextStyle(color: Colors.white, fontSize: 16.0)),
      ),
      body:StreamBuilder(
        stream:ref.onValue,
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasError){
            return const Center(child: Text("Some thing went wrong"));
          }
          else if (snapshot.connectionState == ConnectionState.none){
            return noHistoryYet(context);
          }
          else if (snapshot.connectionState == ConnectionState.waiting ){
            return noHistoryYet(context);
          }
          else if(snapshot.hasData && !snapshot.hasError){
            final event = snapshot.data as DatabaseEvent;
            final snapShot1 = event.snapshot.value;
            if (snapShot1 == null){
              return noHistoryYet(context);
            }
            Map<String,dynamic>map = Map<String,dynamic>.from(snapShot1 as Map);
            final tripList = <TripHistory>[];
            for(var taskMap in map.values){
              TripHistory tripHistory = TripHistory.fromMap(Map<String,dynamic>.from(taskMap));
              // Provider.of<TripHistoryProvider>(context,listen: false).updateState(tripHistory);
              tripList.add(tripHistory);
            }
            return ListView.builder(
              itemBuilder:(context,index){
              return tripListItems(context,index,tripList);
            },
            itemCount:tripList.length ,
            );
          }
          return const Center(child: Text("null"));
        },
      )
    ));
  }

//list of trip history from realTime
  Widget tripListItems(BuildContext context, int index, List<TripHistory> tripList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        height: MediaQuery.of(context).size.height * 15 / 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow:const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 0.7,
              spreadRadius: 3.0,
              offset: Offset(0.7,0.7)
            ),
          ] ,
            color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(tripList[index].pickAddress),
                ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text("To",style: TextStyle(color: Colors.greenAccent.shade700),),
                 ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(tripList[index].dropAddress),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("\$${tripList[index].total}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(tripList[index].trip,style: TextStyle(color: Colors.greenAccent.shade700),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//if history is empty
  Widget noHistoryYet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset('images/lf30_editor_piexm8l1.json',fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height*60/100,
              width: MediaQuery.of(context).size.width*60/100,),
            const Text(
              "History is empty",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
// this method for clear history trip driver
  clearHistory() async {
    ref = FirebaseDatabase.instance.ref().child("driver")
        .child(currentUser!.uid)
        .child("history");
    await ref.remove();
  }
}
