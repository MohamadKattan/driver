import 'package:driver/config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../repo/auth_srv.dart';
import '../widget/custom_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final currentUser = AuthSev().auth.currentUser;
  late DatabaseReference ref;
  double myRating = 0.0;
  @override
  void initState() {
    getRating();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFFFD54F),
              title:  Text(AppLocalizations.of(context)!.myRating,
                  style:const TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
            body:myRating==0.0?noRatingYet(context):dailog(myRating,context),
            ));
  }

  //if history is empty
  Widget noRatingYet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset(
              'images/97585-star.json',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height * 60 / 100,
              width: MediaQuery.of(context).size.width * 60 / 100,
            ),
             Text(
              AppLocalizations.of(context)!.noRating,
              style:const TextStyle(
                  color: Colors.black87,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold),textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget dailog(double myRate,BuildContext context) {
    return
      Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*30/100),
               Center(
                 child: Text(
                  AppLocalizations.of(context)!.myRating,
                  style:const TextStyle(
                      color: Colors.black87,
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold),
              ),
               ),
              SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
              SmoothStarRating(
                allowHalfRating: true,
                starCount: 5,
                rating: myRate,
                size: 50.0,
                color: Colors.yellow.shade700,
                borderColor: Colors.yellow,
                spacing:0.0,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 1 / 100),
              CustomDivider().customDivider(),
            ],
          ),
        ),
    );
  }

  // get rating
 getRating()async{
 DatabaseReference ref =  FirebaseDatabase.instance
      .ref()
      .child("driver")
      .child(currentUser!.uid);
     ref.onValue.listen((value)async{
      if(value.snapshot.value == null){
        return;
      }
      Map<String,dynamic>map = Map<String,dynamic>.from(value.snapshot.value as Map);
      if(!mounted) return;
       setState(() {
         myRating = double.parse(map["rating"].toString());
       });
    });
}
}
