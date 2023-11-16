import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/OTP_Page.dart';
import 'package:flutter_application_2/SigninPage.dart';
import 'package:flutter/gestures.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class PhoneNumberValidator {
  static bool validatePhoneNumber(String phoneNumber) {
    return phoneNumber.length == 13 &&
        phoneNumber.startsWith('+966') &&
        phoneNumber.replaceAll(RegExp(r'[^\d]'), '+').length == 13;
  }
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool isPhoneNumberValid = true;
  bool phoneNumberExists = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseAuth.instance.signOut();
    }
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

//phone validation
  void _validatePhoneNumber(String phoneNumber) {
    if (PhoneNumberValidator.validatePhoneNumber(phoneNumber)) {
      setState(() {
        isPhoneNumberValid = true;
        isButtonEnabled = true;
      });
      _checkPhoneNumberExistAndSave(phoneNumber);
    } else {
      setState(() {
        isPhoneNumberValid = false;
        isButtonEnabled = false;
      });
    }
  }

//check if the phone is already exist or not
  void _checkPhoneNumberExistAndSave(String phoneNumber) {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('User');

    userCollection
        .where('PhoneNumber', isEqualTo: phoneNumber)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          phoneNumberExists = true;
          isButtonEnabled = false;
        });
      } else {
        setState(() {
          phoneNumberExists = false;
        });
      }
    }).catchError((error) {
      print('Error checking phone number: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking phone number')),
      );
    });
  }

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
                stops: [0.0, 0.5, 0.6, 0.8, 1.0],
                colors: [
                  Color.fromRGBO(0, 167, 157, 0.99),
                  Color(0xFF262262),
                  Color(0xFF262262),
                  Color(0xFF262262),
                  Color(0xFF262262),
                ],
              ),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 23.0, right: 5.0),
                  child: Image(
                    image: AssetImage(
                        'assets/images/Hather logo - NO BG-10_2.png'),
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
                          color: Colors.white,
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
                          color: Colors.white,
                          fontFamily: 'IBMPlexSansArabic',
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 55.0, left: 55.0, top: 75.0),
                  child: Column(
                    children: [
                      TextField(
                        //phone number field
                        controller: _phoneNumberController,
                        onChanged: _validatePhoneNumber, //call the method
                        decoration: InputDecoration(
                          hintText: 'ادخل رقم الجوال',
                          hintTextDirection: TextDirection.rtl,
                          hintStyle: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: _phoneNumberController.text.isEmpty
                                  ? Colors.grey
                                  : (isPhoneNumberValid
                                      ? Color(0xff00A79D)
                                      : Colors.red),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: _phoneNumberController.text.isEmpty
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
                          color: Colors.white,
                        ),
                        maxLength: 13, //
                      ),
                      if (_phoneNumberController.text.isNotEmpty) ...[
                        if (!isPhoneNumberValid) //display error message if not valid
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 0, left: 120.0),
                            child: Center(
                              child: Text(
                                ' ! يجب أن يبدأ ب +966 ويكون من 13 خانة * ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red,
                                  fontFamily: 'IBMPlexSansArabic',
                                ),
                              ),
                            ),
                          ),
                        if (isPhoneNumberValid &&
                            phoneNumberExists) //display error message if phone exist
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, left: 210.0),
                            child: Center(
                              child: Text(
                                'رقم الجوال مسجل لدينا من قبل * ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red,
                                  fontFamily: 'IBMPlexSansArabic',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),

// button is enabled when isButtonEnabled is true
                Padding(
                  padding:
                      const EdgeInsets.only(top: 50, right: 55.0, left: 55.0),
                  child: ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            //When pressed it checks if a phone number is valid and if it doesn't already exist

                            String phoneNumber = _phoneNumberController.text;

                            if (isPhoneNumberValid && !phoneNumberExists) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //If these conditions are met, it navigates to another page with passing the phone number
                                  builder: (context) => OTP_Page(
                                    phoneNumber: phoneNumber,
                                    isSignin: false,
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
                    child: Container(
                      width: 395,
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(
                        'تحقق',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontFamily: 'IBMPlexSansArabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPhoneNumberValid
                          ? Color(0xff00A79D)
                          : Color(
                              0xff00A79D), // changed the color from grey to blue
                      disabledForegroundColor:
                          Color(0xff00A79D).withOpacity(0.38),
                      disabledBackgroundColor: Color(0xff00A79D).withOpacity(
                          0.12), // added this line to set the disable color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),

                //if user has an account then navigate them to signin page
                Padding(
                  padding: const EdgeInsets.only(
                      right: 50.0, left: 50.0, top: 140.0, bottom: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          height: 2,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'أو',
                          style: TextStyle(
                            fontSize: 24.0,
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
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'لديك حساب بالفعل؟ ',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontFamily: 'IBMPlexSansArabic',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'سجل دخولك',
                        style: TextStyle(
                          fontSize: 26.0,
                          color: Colors.white,
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
      ),
    );
  }
}