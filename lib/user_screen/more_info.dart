import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreInfo extends StatelessWidget {
  const MoreInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  color:const Color(0xFF00A3E0),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(onPressed: ()=>Navigator.pop(context), icon:const Icon(Icons.arrow_back_ios,color: Colors.white,)),
                      Center(child: Image.asset("images/infoIcon.png",height: 80,width: 80)),
                     const Padding(
                       padding: EdgeInsets.all(12.0),
                       child: Text(""),
                     )
                    ],
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Garanti Taxi",style: TextStyle(color:Color(0xFF00A3E0),fontWeight: FontWeight.bold,fontSize: 24 ),),
                  ),
                ),
                 Center(
                   child: Text(AppLocalizations.of(context)!.world,style:
                   const TextStyle(color:Color(0xFF00A3E0),fontWeight: FontWeight.bold,fontSize: 24 ),),
                 ),
              const  SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(AppLocalizations.of(context)!.carMod,style:
                      const TextStyle(color:Color(0xFF00A3E0),fontWeight: FontWeight.bold,fontSize: 20 )),
                    ),
                    const  SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Image.asset("images/Varlık 8.png",height: 80,width: 80),
                    ),
                    Text(AppLocalizations.of(context)!.s1,style:
                    const TextStyle(color:Color(0xFF00A3E0),fontWeight: FontWeight.bold,fontSize: 16 )),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Image.asset("images/Varlık 9.png",height: 80,width: 80),
                    ),
                    Text(AppLocalizations.of(context)!.s2,style:
                    const TextStyle(color:Color(0xFF00A3E0),fontWeight: FontWeight.bold,fontSize: 16 )),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Image.asset("images/Varlık 10.png",height: 80,width: 80),
                    ),
                    Text(AppLocalizations.of(context)!.s3,style:
                    const TextStyle(color:Color(0xFF00A3E0),fontWeight: FontWeight.bold,fontSize: 16 )),
                    Image.asset("images/Varlık 7.png",height: 80,width: MediaQuery.of(context).size.width),
                    Image.asset("images/Varlık 5.png",height: 80,width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.s4,style:
                        const TextStyle(color:Color(0xFF00A3E0),fontWeight: FontWeight.bold,fontSize: 20 )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context)!.s5,style:
                      const TextStyle(color:Color(0xFF00A3E0),fontWeight: FontWeight.bold,fontSize: 14 )),
                    ),
                    Image.asset("images/Varlık 7.png",height: 80,width: MediaQuery.of(context).size.width),
                    Image.asset("images/Varlık 6.png",height: 80,width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.s6,style:
                        const TextStyle(color:Color(0xFF00A3E0),fontWeight: FontWeight.bold,fontSize: 20 )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context)!.s7,style:
                      const TextStyle(color:Color(0xFF00A3E0),fontWeight: FontWeight.bold,fontSize: 14 )),
                    ),
                  ],
                )
              ],
            ),
          ),
    ));
  }
}
