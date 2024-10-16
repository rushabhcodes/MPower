import 'package:client/pages/home/docter_home_screen.dart';
import 'package:client/pages/login/doctor_signup_page.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/home/home_page.dart';
import 'package:client/pages/intro/intro_page.dart';
import 'package:client/pages/login/login_page.dart';
import 'package:client/pages/login/signin_page.dart';
import 'package:client/pages/login/signup_page.dart';
import 'package:client/pages/login/user_data_page.dart';
import 'package:client/pages/profile/reset_password_page.dart';

class Routes {
  static const String introScreen = '/';
  static const String loginScreen = '/login';
  static const String signupScreen = '/signup';
  static const String signinScreen = '/signin';
  static const String homeScreen = '/home';
  static const String resetPasswordScreen = '/reset_password';
  static const String userDataCollection = '/user_data_collection';
  static const String doctorSignupScreen = '/doctor_signup';
  static const String doctorHomeScreen = '/doctor_home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case introScreen:
        return MaterialPageRoute(builder: (_) => IntroScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signupScreen:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case signinScreen:
        return MaterialPageRoute(builder: (_) => SigninScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case resetPasswordScreen:
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      case userDataCollection:
        return MaterialPageRoute(builder: (_) => UserDataCollection());
      
      case doctorSignupScreen:
        return MaterialPageRoute(builder: (_) => DoctorSignupScreen());
        
      case doctorHomeScreen:
        return MaterialPageRoute(builder: (_) => DoctorHomeScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('ERROR: Page not found'),
        ),
      );
    });
  }
}
