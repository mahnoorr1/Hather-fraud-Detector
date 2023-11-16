import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/HomePage.dart';
import 'package:flutter_application_2/SigninPage.dart';
import 'package:flutter_application_2/SignupPage.dart';
import 'package:flutter_application_2/TermsConditions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_2/PrivacyPolicy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'RequestsPage.dart';

// SettingsPage is a Flutter stateful widget responsible for displaying user settings.
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State {
  // Firebase Authentication and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// User information placeholders
  String userName = "Loading..";
  String phoneNumber = "Loading..";
  @override
  void initState() {
    super.initState();

// Initialize user data when the page is loaded
    fetchUserData();
  }

/*
  - This method is responsible for fetching user data from Firebase Firestore.
  - It retrieves the current user using FirebaseAuth and queries the Firestore collection to find the user document based on their User ID.
  - If the user document exists, it updates the userName and phoneNumber variables using the data retrieved from the document.
  - If the user document doesn't exist, it prints a message indicating that the document is missing.
  - If there is an error during the data fetching process, it prints the error message.
      */
  Future<void> fetchUserData() async {
    // Access the current user
    final User? user = _auth.currentUser;

    // Check if a user is signed in
    if (user != null) {
      // Retrieve user data from Firestore
      try {
        final QuerySnapshot querySnapshot = await _firestore
            .collection("User")
            .where("UserId", isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final DocumentSnapshot userDoc = querySnapshot.docs.first;

          setState(() {
            userName = userDoc["UserName"];
            phoneNumber = userDoc["PhoneNumber"];
          });
        } else {
          print("Document does not exist for user: ${user.uid}");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    } else {
      print("null data");
    }
  }

/*
   - This method is used to launch a social media app if it is installed on the device.
   - It takes a url parameter that represents the social media app's URL.
   - It attempts to launch the app using the launch function from the url_launcher package.
   - If the app is not installed or launching fails, it falls back to launching the URL in a web browser.
      */
  Future<void> _launchSocialMediaAppIfInstalled({
    required String url,
  }) async {
    try {
      bool launched = await launch(url, forceSafariVC: false);

      if (!launched) {
        launch(url);
      }
    } catch (e) {
      launch(url);
    }
  }

// Builds the UI for the settings page.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFF262262),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.45, 0.6, 0.8, 1.0],
                  colors: [
                    Color.fromRGBO(0, 167, 157, 0.99),
                    Color(0xFF262262),
                    Color(0xFF262262),
                    Color(0xFF262262),
                    Color(0xFF262262),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            height: 2,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                          child: Text(
                            'معلومات الحساب',
                            style: TextStyle(
                              fontSize: 34.0,
                              color: Colors.white,
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            height: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // User Information Section
                  Positioned(
                    top: 150,
                    left: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 250,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Color(0xffC7C9CF),
                                    fontFamily: 'IBMPlexSansArabic',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 83),
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          children: [
                            Container(
                              width: 250,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  phoneNumber,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Color(0xffC7C9CF),
                                    fontFamily: 'IBMPlexSansArabic',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 24),
                          ],
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: 200,
                    right: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'الإسم',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          'رقم الجوال',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),

                  // Logout Action
                  Positioned(
                    top: 340,
                    right: 150,
                    child: GestureDetector(
                      onTap: () {
                        _logoutWidget(context);
                      },
                      child: Row(
                        children: [
                          Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Color(0xffEA4335),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBMPlexSansArabic',
                            ),
                          ),
                          SizedBox(width: 26),
                          Icon(
                            Icons.logout,
                            color: Color(0xffEA4335),
                            size: 33,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Delete Account Action
                  Positioned(
                    top: 420,
                    right: 155,
                    child: GestureDetector(
                      onTap: () {
                        _showDeleteAccountDialog(context);
                      },
                      child: Row(
                        children: [
                          Text(
                            ' حذف الحساب ',
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Color(0xffEA4335),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBMPlexSansArabic',
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(
                            FontAwesomeIcons.userTimes,
                            color: Color(0xffEA4335),
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 530,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            height: 2,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                          child: Text(
                            'المزيد',
                            style: TextStyle(
                              fontSize: 34.0,
                              color: Colors.white,
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            height: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Privacy Policy Navigation
                  Positioned(
                    top: 630,
                    left: 85,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PrivacyPolicy()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 33,
                          ),
                          SizedBox(width: 150),
                          Text(
                            'سياسة الخصوصية',
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontFamily: 'IBMPlexSansArabic',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),

                  // Terms and Conditions Navigation
                  Positioned(
                    top: 700,
                    left: 85,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TermsConditions()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 33,
                          ),
                          SizedBox(width: 160),
                          Text(
                            'الأحكام و الشروط',
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontFamily: 'IBMPlexSansArabic',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 820,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            height: 2,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                          child: Text(
                            'أين تجدنا',
                            style: TextStyle(
                              fontSize: 34.0,
                              color: Colors.white,
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            height: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Social Media Links
                  Positioned(
                    top: 915,
                    left: 130,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _launchSocialMediaAppIfInstalled(
                              url: 'https://twitter.com/Hather_app',
                            );
                          },
                          icon: FaIcon(FontAwesomeIcons.twitter),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                        SizedBox(width: 70),
                        IconButton(
                          onPressed: () {
                            _launchSocialMediaAppIfInstalled(
                              url: 'https://instagram.com',
                            );
                          },
                          icon: FaIcon(FontAwesomeIcons.instagram),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                        SizedBox(width: 70),
                        IconButton(
                          onPressed: () {
                            _launchSocialMediaAppIfInstalled(
                              url: 'https://linkedin.com',
                            );
                          },
                          icon: FaIcon(FontAwesomeIcons.linkedin),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar
          bottomNavigationBar: Container(
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(45.0)),
              ),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.home_outlined),
                        iconSize: 45,
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                      ),
                    ],
                  ),

                  // Messages Navigation
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.message_outlined),
                        iconSize: 45,
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestsPage()),
                          );
                        },
                      ),
                    ],
                  ),

                  // Settings Navigation
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings_outlined),
                        iconSize: 50,
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsPage()),
                          );
                        },
                      ),
                      Icon(Icons.fiber_manual_record,
                          size: 15, color: Color(0xff00A79D)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

/*
  - Shows a dialog to confirm account deletion with "Yes" and "No" options.
  - Upon selecting "Yes," the user's account is deleted, and the app navigates
    to the signup page. If the operation fails, an appropriate error message
    is displayed using a SnackBar.
  - Upon selecting "No," the dialog is dismissed, and no action is taken.
      */
  void _showDeleteAccountDialog(BuildContext context) {
    double customWidth = 328.0;
    double customHeight = 410.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: Container(
            width: customWidth,
            height: customHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff262262),
                        fontFamily: 'IBMPlexSansArabic',
                      ),
                      children: [
                        TextSpan(text: "هل أنت متأكد من \n"),
                        WidgetSpan(
                          child: SizedBox(height: 40.0),
                        ),
                        TextSpan(text: "حذف الحساب ؟"),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      onPressed: () async {
                        try {
                          await deleteAccount();
                          await FirebaseAuth.instance.signOut();

                          // Check if the user is successfully signed out
                          if (FirebaseAuth.instance.currentUser == null) {
                            // The user is successfully signed out
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          } else {
                            // Handle any issues that might occur during sign-out
                            // Display an error message or handle the situation as needed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "عملية حذف الحساب فشلت, حاول مرة اخرى"),
                              ),
                            );
                          }
                        } catch (e) {
                          // Handle any exceptions that might occur during sign-out
                          // Display an error message or log the error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "حدث خطأ اثناء حذف الحساب, حاول مرة اخرى"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 80.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 1.0],
                            colors: [
                              Color(0xFF00A79D),
                              Color(0xFF262262),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "نعم",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 80.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 1.0],
                            colors: [
                              Color(0xFF00A79D),
                              Color(0xFF262262),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "لا",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Handles the logic for deleting the user account.

  Future<void> deleteAccount() async {
    try {
      // Access the current user
      User? user = FirebaseAuth.instance.currentUser;

// Check if a user is signed in
      if (user != null) {
        // Delete the user's profile data from Firestore
        final userPhone = user.phoneNumber;

        final userQuerySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('UserId', isEqualTo: user.uid)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          final userDoc = userQuerySnapshot.docs.first;
          await userDoc.reference.delete();
          await user.delete();
        }
      } else {
        print("User is null");
      }
    } catch (error) {
      print('Error deleting account: $error');
      // Show an error message or perform appropriate error handling
    }
  }

  // Shows a dialog to confirm logout and handles the associated logic.
  void _logoutWidget(BuildContext context) {
    double customWidth = 328.0;
    double customHeight = 410.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: Container(
            width: customWidth,
            height: customHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff262262),
                        fontFamily: 'IBMPlexSansArabic',
                      ),
                      children: [
                        TextSpan(text: "هل أنت متأكد من \n"),
                        WidgetSpan(
                          child: SizedBox(height: 40.0),
                        ),
                        TextSpan(text: "   تسجيل الخروج"),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      onPressed: () async {
                        try {
                          // Sign out the user using Firebase Authentication
                          await FirebaseAuth.instance.signOut();

                          // Check if the user is successfully signed out
                          if (FirebaseAuth.instance.currentUser == null) {
                            // The user is successfully signed out
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SigninPage(),
                              ),
                            );
                          } else {
                            // Handle any issues that might occur during sign-out
                            // Display an error message or handle the situation as needed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "عملية تسجيل الخروج فشلت, حاول مرة اخرى"),
                              ),
                            );
                          }
                        } catch (e) {
                          // Handle any exceptions that might occur during sign-out
                          // Display an error message or log the error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "حدث خطأ اثناء تسجيل الخروج, حاول مرة اخرى"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 80.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 1.0],
                            colors: [
                              Color(0xFF00A79D),
                              Color(0xFF262262),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "نعم",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 80.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 1.0],
                            colors: [
                              Color(0xFF00A79D),
                              Color(0xFF262262),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "لا",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}