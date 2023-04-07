/*
import 'package:flutter/material.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:lottie/lottie.dart';

import 'navService.dart';

Widget loadingIcon(){
  BuildContext context = NavigationService.navigatorKey.currentContext!;
  String loadingLottie = '';
  if(!currentTheme){
    loadingLottie = "loading/normalLoadingIcon.json";
  }else{
    loadingLottie = "loading/normalLoadingIconWhite.json";
  }
  */
/*if(MyGlobals().getSpecialTheme() == "Halloween" && option == 0){
    loadingGif = "assets/loading/pumpkinLoading.gif";
  }else if(MyGlobals().getSpecialTheme() == "Halloween" && option == 1){
    loadingGif = "assets/loading/pumpkinLoading2.gif";
  }*//*

  return Container(
    // margin: EdgeInsets.only(right: 20),
      width: MediaQuery.of(context).size.width/5, height: MediaQuery.of(context).size.height/5,
      child: Lottie.asset(loadingLottie)
  );
}*/
