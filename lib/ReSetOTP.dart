import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/REsetPage.dart';

//  step 2 : OTP page for Reset the password 

class ReSetOTP extends StatefulWidget {
  final String phoneNumber;

  final bool isSignin;

  ReSetOTP({Key? key, required this.phoneNumber, required this.isSignin})  // 2 required parameters 
      : super(key: key);

  @override
  _OTP_PageState createState() => _OTP_PageState(phoneNumber);
}

class _OTP_PageState extends State<ReSetOTP> {

  bool isAnyBoxEmpty = false; //boolean variable used for checking whether any of the OTP input boxes are empty.

  FirebaseAuth auth = FirebaseAuth.instance;

  // Initializes a list of TextEditingController objects with 6 elements.
  // These controllers will be used to manage the input text for each of the 6 OTP input boxes.
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  List<FocusNode> otpFocusNodes = List.generate(6, (index) => FocusNode());

  String errorMessage = '';
  String phoneNumber;

  _OTP_PageState(this.phoneNumber);

  @override
  void initState() {
    phoneAuth(phoneNumber);
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
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
                padding: const EdgeInsets.only(top: 23.0),
                child: Image(
                  image:
                      AssetImage('assets/images/Hather logo - NO BG-01_2.png'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: Text(
                      'رمز التحقق',
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
                    padding: const EdgeInsets.only(right: 40.0, top: 20.0),
                    child: Text(
                      'قم بإدخال رمز التحقق المكون من 6 ارقام ',
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

              // OTP entering boxes 
              Padding(
                padding: const EdgeInsets.only(
                    top: 65.0, bottom: 65.0, right: 30.0, left: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildOTPBox(1),// bulidOTPBox it is  a widgit that contain the boxes design 
                    buildOTPBox(2),// and how it move from box to another in typing 
                    buildOTPBox(3),
                    buildOTPBox(4),
                    buildOTPBox(5),
                    buildOTPBox(6),
                  ],
                ),
              ),


              // Display the error message
              if (errorMessage.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.red,
                        fontFamily: 'IBMPlexSansArabic',
                      ),
                    ),
                  ),
                ),

              Padding(//
                padding: const EdgeInsets.only(top: 50.0, bottom: 55.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Check if any box is empty
                    if (otpControllers
                        .any((controller) => controller.text.isEmpty)) {
                      setState(() {
                        isAnyBoxEmpty = true;//
                        errorMessage =
                            'يرجى ملء جميع المربعات *'; // Optional error message for empty boxes
                      });
                      return; // Don't proceed further
                    }



                    
                    final enteredOTP = otpControllers
                        .map((controller) => controller.text)
                        .join('');
                    final expectedOTP = '123456';

                    // Cheack the enterd code with the expected one 
                    if (enteredOTP == expectedOTP) {
                      //navigate to ResetPage 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              REsetPage(phoneNumber: phoneNumber),
                        ),
                      );
                    } else {
                      setState(() {
                        errorMessage = 'رمز التحقق غير صحيح *'; // Error message if the code not matching
                      });
                    }
                  },

                  // continue button (it disabeld untill the code is correct )
                  child: Container(
                    width: 435,
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      'استمرار',
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

              // resend rich text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'لم يصلك رمز التحقق؟ ',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Color(0xff262262),
                    fontFamily: 'IBMPlexSansArabic',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' ارسل مرة اخرى',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xff00A79D),
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          phoneAuth(phoneNumber);
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

  Widget buildOTPBox(int boxNumber) {
    return Padding(
      padding: const EdgeInsets.only(right: 3.0, left: 3.0),
      child: Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: isAnyBoxEmpty 
            ? Colors.red         // if some boxse are empty  the border will turend to red 
            : Color(0xff00A79D), // if the all boxes filled will turend to green 

            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ), //
        child: Center(
          child: TextField(
            controller: otpControllers[boxNumber - 1],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.black,
              fontFamily: 'IBMPlexSansArabic',
              fontWeight: FontWeight.w600,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (boxNumber < otpControllers.length) {

                  // Move the focus to the next box ( let the user to enter the next box auto )
                  FocusScope.of(context).requestFocus(otpFocusNodes[boxNumber]);
                }
              }
            },
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            focusNode: otpFocusNodes[boxNumber - 1], // Assign the focus node
          ),
        ),
      ),
    );
  }

  Future<void> phoneAuth(phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(

       //This parameter specifies the phone number that is passed to the function from the widget. 
      // It is the phone number that will be verified
      phoneNumber: phoneNumber, 

      timeout: const Duration(seconds: 120),


      // when the verification is completed , it signs in the user with the provided credential and navigate To REsetPage
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
           Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              REsetPage(phoneNumber: phoneNumber),
                        ),
                      );
      },

      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        String expectedOTP = '123456';
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: expectedOTP);
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }




}
