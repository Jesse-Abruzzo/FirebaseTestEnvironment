import 'package:flutter/material.dart';

AssetImage? backgroundPicker(){
  int month = DateTime.now().month;
  switch (month){
    case 4:
      return const AssetImage("assets/holidayBackgrounds/easter.jpg");
    case 12:
      return const AssetImage("assets/holidayBackgrounds/christmas.jpg");
    case 10:
      return const AssetImage("assets/holidayBackgrounds/halloween.jpeg");
    case 7:
      return const AssetImage("assets/holidayBackgrounds/july.jpg");
    case 9:
      return const AssetImage("assets/holidayBackgrounds/novemeber.jpeg");
    case 2:
      return const AssetImage("assets/holidayBackgrounds/february.jpg");
    case 1:
      return const AssetImage("assets/holidayBackgrounds/january.jpg");
    default:
      return null;
  }
}