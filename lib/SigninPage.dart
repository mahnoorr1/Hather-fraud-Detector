import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/OTP_Page.dart';
import 'package:flutter_application_2/SignupPage.dart';
import 'package:flutter_application_2/AdminPages/RequestsPageAdmin.dart';
import 'package:flutter_application_2/ResetPass.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State {
  //use it with name filed
  final TextEditingController _phoneNumberController = TextEditingController();
  bool isPhoneNumberValid = true;
  //use it with password filed
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordValid = true;
  String errorMessage = '';

  @override

  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }
//making sure the phone is valid
  void _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 13 &&
        phoneNumber.startsWith('+966') &&
        phoneNumber.replaceAll(RegExp(r'[^\d]'), '+').length == 13) {
      setState(() {
        isPhoneNumberValid = true;
      });
    } else {
      setState(() {
        isPhoneNumberValid = false;
      });
    }
  }

  //password validation
  void _validatePassword(String password) {
    if (password.length >= 6) {
      setState(() {
        isPasswordValid = true;
      });
    } else {
      setState(() {
        isPasswordValid = false;
      });
    }
  }

  //sign In Validation
  Future<void> signInWithPhoneAndPassword(
      String phoneNumber, String password) async {
    try {
      // Validate phone number and password 
      if (isPhoneNumberValid && isPasswordValid) {
        final adminQuery = await FirebaseFirestore.instance
        //check if it is an admin (the admin has special password and phone number)
            .collection('Admin')
            .where('AdminPhone', isEqualTo: phoneNumber)
            .where('AdminPassword', isEqualTo: password)
            .get();

        if (adminQuery.docs.isNotEmpty) {
          // The user is an admin
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RequestsPageAdmin(), // Navigate to the admin page
            ),
          );
        } else { //of not admin, check the user collection 
          final userQuery = await FirebaseFirestore.instance
              .collection('User')
              .where('PhoneNumber', isEqualTo: phoneNumber)
              .get();

          if (userQuery.docs.isNotEmpty) {
            final userData = userQuery.docs[0].data() as Map<String, dynamic>;
            final storedPassword = userData['Password'];
             //check the entered password = storedPassword 
            if (storedPassword == password) {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OTP_Page(phoneNumber: phoneNumber, isSignin: true),
                ),
              );
            } else {
              // Set error message for incorrect password
              setState(() {
                errorMessage = ' كلمة المرور غير صحيحة  *';
              });
            }
          } else {
            // Set error message for user not found
            setState(() {
              errorMessage = 'المستخدم غير موجود *';
            });
          }
        }
      } else {
        // Set error message for invalid phone number or password
        setState(() {
          errorMessage = 'رقم الجوال أو كلمة المرور غير صحيحان *';
        });
      }
    } catch (e) {
      // Set error message for other exceptions
      setState(() {
        errorMessage = 'حدث خطأ: $e';
      });
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            //page content
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                  ),
                  child: Image(
                    image: AssetImage(
                        'assets/images/Hather logo - NO BG-01_2.png'),
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
                            fontFamily: 'IBMPlexSansArabi'),
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
                            fontFamily: 'IBMPlexSansArabic'),
                      ),
                    ),
                  ],
                ),

                //phone number field
                Padding(
                  padding: const EdgeInsets.only(
                    right: 55.0,
                    left: 55.0,
                    top: 75.0,
                  ),
                  child: TextField(
                    key: Key('phoneNumberTextField'),
                    controller: _phoneNumberController,
                    onChanged: (PhoneNumber) =>
                        _validatePhoneNumber(PhoneNumber),
                    decoration: InputDecoration(
                      hintText: 'قم بإدخال رقم الجوال',
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
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
                      color: Color(0xff262262),
                    ),
                    maxLength: 13,
                  ),
                ),

// Display error message if num is invalid
                if (!isPhoneNumberValid &&
                    _phoneNumberController.text.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 13.0, right: 50.0),
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

                //password number field 
                Padding(
                  padding: const EdgeInsets.only(
                    right: 55.0,
                    left: 55.0,
                    top: 20.0,
                  ),
                  child: TextField(
                    key: Key('passwordTextField'),
                    controller:
                        _passwordController, // Create a TextEditingController for the password field
                    onChanged: _validatePassword, // Validate as user types
                    obscureText: true, // Hide the entered password

                    decoration: InputDecoration(
                      hintText: 'ادخل كلمة المرور',
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        fontFamily: 'IBMPlexSansArabic',
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: _passwordController.text.isEmpty
                              ? Colors.grey
                              : (isPasswordValid
                                  ? Color(0xff00A79D)
                                  : Colors.red),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: _passwordController.text.isEmpty
                              ? Colors.grey
                              : (isPasswordValid
                                  ? Color(0xff00A79D)
                                  : Colors.red),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xff262262),
                    ),
                    maxLength: 18, // Not allow more than 18 characters
                  ),
                ),

                // Display error message if password is not valid
                if (!isPasswordValid && _passwordController.text.isNotEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 120.0),
                      child: Text(
                        ' ! كلمة المرور يجب ان تكون من 6 خانات و أكثر * ',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.red,
                          fontFamily: 'IBMPlexSansArabic',
                        ),
                      ),
                    ),
                  ),





                if (errorMessage.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 13.0, right: 60.0),
                  child: Text(
                    errorMessage,                    
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 20.0,
                    ),
                  ),
                    ),
                  ),


                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to ResetPass.dart when the text is clicked
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ResetPass()));
                    },
                    child: Text(
                      textAlign: TextAlign.center,
                      'هل نسيت كلمة المرور؟',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Color(0xff262262),
                        fontFamily: 'IBMPlexSansArabic',
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                //Submission button pressed if all conditions and validaion is correct
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_phoneNumberController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty &&
                          isPhoneNumberValid &&
                          isPasswordValid) {
                        final phoneNumber = _phoneNumberController.text;
                        final password = _passwordController.text;
                        signInWithPhoneAndPassword(phoneNumber, password);
                      }
                      // No else part here so if the conditions aren't met, the button just does nothing
                    },
                    child: Container(
                      width: 435,
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontFamily: 'IBMPlexSansArabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),//
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff00A79D),
                            Color(0xff262262),
                          ],
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

                // Divider with "أو" 
                Padding(
                  padding: const EdgeInsets.only(
                      right: 50.0, left: 50.0, top: 60.0, bottom: 40.0),
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
                //
                // go to sign up page if needed
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: ' ليس لديك حساب؟ ',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Color(0xff262262),
                      fontFamily: 'IBMPlexSansArabic',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' أنشئ حساب',
                        style: TextStyle(
                          fontSize: 26.0,
                          color: Color(0xff262262),
                          fontFamily: 'IBMPlexSansArabic',
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                        // Add an onTap callback to handle the click
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Add login navigation logic
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
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
        ));
  }
}