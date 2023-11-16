import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/SigninPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddnamePage extends StatefulWidget {
  final String phoneNumber;

//the phone number is passed from signup page and otp page so it can be add to firebase with other fields
  const AddnamePage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _AddnamePageState createState() => _AddnamePageState();
}

class PasswordConfirmationValidator {
  static bool validatePasswordConfirmation(
      String password, String confirmPassword) {
    return password == confirmPassword;
  }
}

class PasswordValidator {
  static bool validatePassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length >= 8;

    return hasDigits &&
        hasUppercase &&
        hasLowercase &&
        hasSpecialCharacters &&
        hasMinLength;
  }
}

class NameValidator {
  static bool validateName(String name) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(name);
  }
}

class _AddnamePageState extends State<AddnamePage> {
  final TextEditingController _NameController = TextEditingController();
  bool isNameValid = true;

  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordValid = true;

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool doPasswordsMatch = true;

  @override
  void dispose() {
    _NameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //making sure the name only has letters
  void _validateName(String name) {
    if (NameValidator.validateName(name)) {
      setState(() {
        isNameValid = true;
      });
    } else {
      setState(() {
        isNameValid = false;
      });
    }
  }

  void _validatePassword(String password) {
    if (PasswordValidator.validatePassword(password)) {
      setState(() {
        isPasswordValid = true;
      });
    } else {
      setState(() {
        isPasswordValid = false;
      });
    }
  }

  //making sure the password is confirmed when writing it twice
  void _validatePasswordConfirmation(String password) {
    final String originalPassword = _passwordController.text;
    if (PasswordConfirmationValidator.validatePasswordConfirmation(
        password, originalPassword)) {
      setState(() {
        doPasswordsMatch = true;
      });
    } else {
      setState(() {
        doPasswordsMatch = false;
      });
    }
  }

//add the user information to firebase
  Future<void> _addUserToFirestore(
    String name,
    String password,
    String phoneNumber,
  ) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;

      if (auth.currentUser != null) {
        await firestore.collection('User').add({
          "UserId": auth.currentUser!.uid,
          'UserName': name,
          'Password': password,
          'PhoneNumber': phoneNumber,
        });
      } else {
        // Handle the error
      }
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF262262),
        body: SafeArea(
          child: ListView(
            children: [
              Container(
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, right: 5.0),
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
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 60.0, top: 20.0),
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
                      padding: const EdgeInsets.only(
                        right: 55.0,
                        left: 55.0,
                        top: 75.0,
                      ),
                      child: TextField(
                        controller: _NameController, //name variable
                        onChanged: _validateName, //calling the method to check
                        decoration: InputDecoration(
                          hintText: 'ادخل اسمك',
                          hintTextDirection: TextDirection.rtl,
                          hintStyle: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.grey, // Default color
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: _NameController.text.isEmpty
                                  ? Colors.grey
                                  : isNameValid
                                      ? Color(0xff00A79D)
                                      : Colors
                                          .red, // Color when enabled based on validity or emptiness
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: _NameController.text.isEmpty
                                  ? Colors.grey
                                  : isNameValid
                                      ? Color(0xff00A79D)
                                      : Colors
                                          .red, // Color when focused based on validity or emptiness
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                        maxLength: 35,
                      ),
                    ),
                    if (!isNameValid &&
                        _NameController.text
                            .isNotEmpty) //if not valid then show the error message
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 20, left: 200.0),
                        child: Text(
                          ' ! يجب ان يتكون من حروف فقط * ',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.only(
                        right: 55.0,
                        left: 55.0,
                        top: 20.0,
                      ),
                      child: TextField(
                        controller: _passwordController, //pass variable
                        onChanged: _validatePassword, //call the method to check
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'ادخل كلمة المرور',
                          hintTextDirection: TextDirection.rtl,
                          hintStyle: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.grey, // Default color
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: _passwordController.text.isEmpty
                                  ? Colors.grey
                                  : isPasswordValid
                                      ? Color(0xff00A79D)
                                      : Colors
                                          .red, // Color when enabled based on validity or emptiness
                            ),
                          ), //
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: _passwordController.text.isEmpty
                                  ? Colors.grey
                                  : isPasswordValid
                                      ? Color(0xff00A79D)
                                      : Colors
                                          .red, // Color when focused based on validity or emptiness
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                        maxLength: 35,
                      ),
                    ),
                    if (!isPasswordValid &&
                        _passwordController.text
                            .isNotEmpty) //if not valid then show the error message
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 5.0, bottom: 20),
                        child: Text(
                          'يجب أن تتكون كلمة المرور من على الأقل من 8 خانات تتضمن * \n رقم وحرف صغير وحرف كبير \n  (!@#%^&*) ورمز ',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.only(
                        right: 55.0,
                        left: 55.0,
                      ),
                      child: TextField(
                        controller:
                            _confirmPasswordController, //confirmation password variable
                        onChanged:
                            _validatePasswordConfirmation, //call the method to check the matching
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'أعد ادخال كلمة المرور',
                          hintTextDirection: TextDirection.rtl,
                          hintStyle: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.grey, // Default color
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: _confirmPasswordController.text.isEmpty
                                  ? Colors.grey
                                  : doPasswordsMatch
                                      ? Color(0xff00A79D)
                                      : Colors
                                          .red, // Color when enabled based on match or emptiness
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: _confirmPasswordController.text.isEmpty
                                  ? Colors.grey
                                  : doPasswordsMatch
                                      ? Color(0xff00A79D)
                                      : Colors
                                          .red, // Color when focused based on match or emptiness
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                        maxLength: 18,
                      ),
                    ),
                    if (!doPasswordsMatch &&
                        _confirmPasswordController.text
                            .isNotEmpty) //if not matched then show the error message
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                        child: Text(
                          ' ! كلمات المرور غير متطابقة * ',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: ElevatedButton(
                        //when user press the btn, at this point their information will added to firebase
                        onPressed: (_NameController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty &&
                                _confirmPasswordController.text.isNotEmpty &&
                                isNameValid &&
                                isPasswordValid &&
                                doPasswordsMatch)
                            ? () async {
                                await _addUserToFirestore(
                                    _NameController.text,
                                    _passwordController.text,
                                    widget.phoneNumber);

                                _showAccountCreatedDialog(
                                    context); //call the confirmation dialog
                              }
                            : null,
                        child: Container(
                          width: 395,
                          height: 60,
                          alignment: Alignment.center,
                          child: Text(
                            'إرسال',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontFamily: 'IBMPlexSansArabic',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (isNameValid &&
                                  isPasswordValid &&
                                  doPasswordsMatch)
                              ? Color(0xff00A79D)
                              : Color(0xff00A79D),
                          disabledForegroundColor:
                              Color(0xff00A79D).withOpacity(0.38),
                          disabledBackgroundColor:
                              Color(0xff00A79D).withOpacity(0.12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
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

//confirmation dialog
  void _showAccountCreatedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: EdgeInsets.all(16.0),
          title: Column(
            children: [
              Image.asset(
                'assets/images/correct_gif.gif',
                width: 200.0,
                height: 200.0,
              ),
              SizedBox(height: 15),
              Text(
                "تم إنشاء الحساب بنجاح",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff262262),
                  fontFamily: 'IBMPlexSansArabic',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    ),
                    elevation: MaterialStateProperty.all<double>(0),
                  ),
                  onPressed: () {
                    //when press استمرار then navigate them to signin page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 120.0,
                    height: 50.0,
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
                        "استمرار",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontFamily: 'IBMPlexSansArabic',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}