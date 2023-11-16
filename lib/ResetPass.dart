import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/ReSetOTP.dart';
import 'package:flutter_application_2/SigninPage.dart';

//  step 1 : enter the phone number for Reset the password 

class ResetPass extends StatefulWidget {
  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  TextEditingController _PhoneNumberController = TextEditingController();

  bool isPhoneNumberValid = true;  // Used to determine whether the syntax of the entered phone number matches the RegExp.
  bool phoneNotRegistered = false; // Added this to manage showing the error

  RegExp NumRegExp = RegExp(r'^\+966\d{9}$'); //defines a regular expression for saudi numbers that strat with +966

  void _validatePhoneNumber(String PhoneNumber) {
    setState(() {
      isPhoneNumberValid = NumRegExp.hasMatch(PhoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // The page design
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                ),
                child: Image(
                  image:
                      AssetImage('assets/images/Hather logo - NO BG-01_2.png'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 60.0),
                    child: Text(
                      '! اهلاً بك',
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff262262),
                        fontFamily: 'IBMPlexSansArabi',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 60.0, top: 20.0),
                    child: Text(
                      ' أول خطواتك لعالم رقمي آمن',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff262262),
                        fontFamily: 'IBMPlexSansArabic',
                      ),
                    ),
                  ),
                ],
              ),

              // Phone field
              Padding(
                padding: const EdgeInsets.only(
                  right: 55.0,
                  left: 55.0,
                  top: 75.0,
                ),
                child: TextField(
                  controller: _PhoneNumberController,
                  //once the user enter the number will pass it to _validatePhoneNumber to check the syntax
                  onChanged: (PhoneNumber) => _validatePhoneNumber(PhoneNumber),
                  decoration: InputDecoration(
                    hintText: 'قم بإدخال رقم الجوال',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                      fontFamily: 'IBMPlexSansArabic',
                    ),
 
                    // If the _PhoneNumberController text is empty, the border color is set to grey.
                    // If the phone number is valid, the border color is set to green.
                    //If the phone number is not valid, the border color is set to red.

                    // It is the initial state of the border before the user starts typing or interacting with the TextField
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: _PhoneNumberController.text.isEmpty
                            ? Colors.grey
                            : (isPhoneNumberValid
                                ? Color(0xff00A79D)
                                : Colors.red),
                      ),
                    ),

                    // It is how the border should look when the user is actively interacting with the TextField
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: _PhoneNumberController.text.isEmpty
                            ? Colors.grey
                            : (isPhoneNumberValid
                                ? Color(0xff00A79D)
                                : Colors.red),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xff262262),
                  ),
                  maxLength: 13,
                ),
              ),

              // Display error message if num is invalid 
              if (!isPhoneNumberValid && _PhoneNumberController.text.length >= 1)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 50.0),
                    child: Text(
                      ' !  يجب أن يبدأ ب +966 ويكون من 13 خانة * ',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                        fontFamily: 'IBMPlexSansArabic',
                      ),
                    ),
                  ),
                ),

              // Display the error message if the number is not registered
              if (isPhoneNumberValid && phoneNotRegistered)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 50.0),
                    child: Text(
                      '!  رقم الجوال غير مسجل لدينا * ',//
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                        fontFamily: 'IBMPlexSansArabic',
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ElevatedButton(
                  //  once the user press on the butten :
                  // will verifying whether a phone number that enterd exists in the database.
                  
                  onPressed: () {
                    if (_PhoneNumberController.text.isNotEmpty &&
                        isPhoneNumberValid) {
                      final PhoneNumber = _PhoneNumberController.text;
                      try {
                        final userSnapshot = FirebaseFirestore.instance
                            .collection('User')
                            .where('PhoneNumber', isEqualTo: PhoneNumber)
                            .get();

                        userSnapshot.then((snapshot) {
                          if (snapshot.docs.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // If the phone number is found, the code navigates to the ReSetOTP page and pass the phone number. 
                                builder: (context) => ReSetOTP(
                                  phoneNumber: PhoneNumber,
                                  isSignin: false,
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              phoneNotRegistered = true;
                            });
                            print("!رقم الجوال غير مسجل لدينا");
                          }
                        });
                      } catch (e) {
                        print('Error: $e');
                      }
                    }
                    // If the conditions aren't met, the button does nothing.
                  },
                  child: Container(
                    width: 435,
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      'اعادة تعيين كلمة المرور',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                      decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff00A79D),
                          Color(0xff262262),
                        ],
                        stops: [0.5, 1.0], 
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                  ),
                ),
              ),

              //
              Padding(
                padding: const EdgeInsets.only(
                    right: 50.0, left: 50.0, top: 90.0, bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        height: 2,
                        color: Color(0xff262262),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        'أو',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xff262262),
                          fontFamily: 'IBMPlexSansArabic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        height: 2,
                        color: Color(0xff262262),
                      ),
                    ),
                  ],
                ),
              ),

              // ritch text to back to log in page 
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'الرجوع لتسجيل الدخول',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xff262262),
                        fontFamily: 'IBMPlexSansArabic',
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SigninPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
