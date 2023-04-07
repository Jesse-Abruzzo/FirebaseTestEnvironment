
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:iot_dashboard/auth/signIn.dart';
import 'package:iot_dashboard/backgroundPicker.dart';
import 'package:iot_dashboard/globals.dart';
import 'package:iot_dashboard/navService.dart';
import 'package:particles_flutter/particles_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 1000);

  //check if already logged in
  //listen for user logged in.

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
     // var user = await signInUsingEmailPassword(email: data.name,password: data.password);
      if(data.name != null){
        String emailNew = data.name;
        if(!emailNew.toLowerCase().contains('@zebra.com')){
          emailNew = data.name + '@zebra.com';
        }
        //check SSO stuff and get data back here
        signInUsingEmailPassword(email: emailNew, password:data.password);
        userInfo = User(emailNew,data.password);
        return null;
      }else{
        return 'Incorrect Login Info';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
    ),home:Scaffold(
        body: Stack(children:[Container(
    decoration: backgroundPicker() != null ? BoxDecoration(
    image: DecorationImage(
    image: backgroundPicker()!,
    fit: BoxFit.cover,
    ),
    ):const BoxDecoration(),child:FlutterLogin(
          logoTag: 'LoginLogo',
          userValidator: (value) {
            if(value!.contains('@') && !value.toLowerCase().contains('@zebra.com')){
              return 'Check your spelling. @' + value.split('@')[1];
            }
          },
          //need to split email cant make key like that in firebase Firebase Database paths must not contain '.', '#', '$', '[', or ']'
        hideForgotPasswordButton: true, //until i get time to make it
          additionalSignupFields: [
            UserFormField(keyName: 'Name', icon: const Icon(Icons.emoji_people_rounded),
              fieldValidator: (value) {
                if (value != null && !value.contains(".")&& !value.contains("#")&& !value.contains('\$')&& !value.contains("[") && !value.contains("]")) {
                  if (value.isEmpty) {
                    return "Not a Valid Name";
                  }
                  return null;
                }else{
                  return "Invalid Character Detected";
                }
              }
              ),
          ],
        theme: LoginTheme(
            pageColorLight:backgroundPicker() != null ?  Colors.transparent:null,
            pageColorDark:backgroundPicker() != null ?  Colors.transparent:null,
        primaryColor: Colors.blueGrey,
        accentColor: Colors.blueGrey,
        errorColor: Colors.redAccent,
        titleStyle: const TextStyle(
        color: Colors.black,
        letterSpacing: 4,
            fontFamily: 'Montserrat'
        ),
      buttonTheme: LoginButtonTheme(
        splashColor: Colors.blueGrey,
        backgroundColor: Colors.black,
        highlightColor: Colors.blueGrey,
        elevation: 9.0,
        highlightElevation: 6.0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        // shape: CircleBorder(side: BorderSide(color: Colors.green)),
        // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      )),
      title: 'IOT Dashboard',
      logo: const AssetImage('assets/zebraBlack.png'),
      onLogin: _authUser,
      onSubmitAnimationCompleted: () async {
       /* Globals().setAdminRights(false);
        if(FirebaseAuth.instance.currentUser != null){
          await checkAdminRights();
        }*/
        Navigator.pushNamed(NavigationService.navigatorKey.currentContext!, '/yieldDashboard');
      }, onRecoverPassword: (String ) {  },
    )
    ),
          DateTime.now().month == 12 || DateTime.now().month == 1 ? IgnorePointer(
              ignoring: true,
              child:CircularParticle(
            // key: UniqueKey(),
            awayRadius: 200,
            numberOfParticles: 200,
            speedOfParticles: 8,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            onTapAnimation: false,
            particleColor: Colors.white.withAlpha(150),
            awayAnimationDuration: Duration(milliseconds: 600),
            maxParticleSize: 8,
            isRandSize: true,
            isRandomColor: false,
            awayAnimationCurve: Curves.easeInOutBack,
            enableHover: false,
            connectDots: false, //not recommended
              )):const SizedBox(), ])));
  }
}