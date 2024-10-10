// login_screen.dart
import 'package:client/utils/navigation.dart';
import 'package:client/utils/theme_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () => Provider.of<ThemeNotifier>(context, listen: false)
                .toggleTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("MPower",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            Spacer(),
            Center(
              child: Image.asset(
                'assets/icon.png',
                width: 100,
                height: 100,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.signinScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.login,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Login',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            signInGoogle(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google-icon.png',
                                height: 20,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.signupScreen);
                        },
                        child: Text(
                          'Sign Up as Patient',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.doctorSignupScreen);
                        },
                        child: Text(
                          'Sign Up as Doctor',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signInGoogle(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pop(context);

      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          final databaseReference = FirebaseDatabase.instance.ref();
          
          // Check both user types (patient and doctor)
          final patientDataSnapshot = await databaseReference
              .child('users')
              .child(userCredential.user!.uid)
              .get();
              
          final doctorDataSnapshot = await databaseReference
              .child('doctors')
              .child(userCredential.user!.uid)
              .get();

          if (patientDataSnapshot.exists) {
            Navigator.pushReplacementNamed(context, Routes.homeScreen);
          } else if (doctorDataSnapshot.exists) {
            Navigator.pushReplacementNamed(context, Routes.doctorHomeScreen);
          } else {
            Navigator.pushReplacementNamed(context, Routes.userDataCollection);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please verify your email before logging in.')),
          );
          bool? resend = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              final theme = Theme.of(context);
              return AlertDialog(
                backgroundColor: theme.colorScheme.background,
                title: Text('Email not verified'),
                content: Text('Would you like to resend the verification email?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('No'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          );
          if (resend == true) {
            await userCredential.user!.sendEmailVerification();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Verification email sent. Please check your inbox.')),
            );
          }
          await FirebaseAuth.instance.signOut();
        }
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Sign in failed: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

// doctor_signup_screen.dart
