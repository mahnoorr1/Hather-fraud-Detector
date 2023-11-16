import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/SigninPage.dart';

//  step 3 : enter the passwords 

class REsetPage extends StatefulWidget {
  final String phoneNumber;

  const REsetPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  REsetPageState createState() => REsetPageState();
}

class REsetPageState extends State<REsetPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordValid = true;

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool doPasswordsMatch = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  
  // Ensuring that users choose secure and strong passwords that meet the specified criteria.

  void _validatePassword(String password) {
    final hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    final hasDigits = password.contains(new RegExp(r'[0-9]'));
    final hasLowercase = password.contains(new RegExp(r'[a-z]'));
    final hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length >= 8;

    if (hasDigits &&
        hasUppercase &&
        hasLowercase &&
        hasSpecialCharacters &&
        hasMinLength) {
      setState(() {
        isPasswordValid = true; // if the enterd password meet all of them 
      });
    } else {
      setState(() {
        isPasswordValid = false; // if somthing messing of the specified criteria 
      });
    }
  }

 // To check if the first field of password match the confermation field password 
  void _validatePasswordConfirmation(String password) {
    final String originalPassword = _passwordController.text;
    if (password == originalPassword) {
      setState(() {
        doPasswordsMatch = true;
      });
    } else {
      setState(() {
        doPasswordsMatch = false;
      });
    }
  }


  // Resetting the password of a currently signed-in user in a Firebase application
  Future<void> _resetPassword(String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (auth.currentUser != null) { // checks if a user is currently signed in
      try {
        await auth.currentUser!.updatePassword(password);

       // retrieves the user collection reference from the Firestore
        CollectionReference usersCollection = firestore.collection('User'); 

        usersCollection
            .where('UserId', isEqualTo: auth.currentUser!.uid) //check if the current user id match the user id in DB
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            var documentReference = querySnapshot.docs[0].reference;

            // Update the password 
            documentReference.update({'Password': password}).then((value) {
              print('Data updated successfully');
            }).catchError((error) {
              print('Error updating data: $error');
            });
          } else {
            print('Document not found for user: ${auth.currentUser!.uid}');
          }
        }).catchError((error) {
          print('Error searching for the user document: $error');
        });
      } catch (e) {
        print('Error updating password: $e');
      }
    } else {
      print('User is not signed in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // the page design 
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
                        top: 20.0,
                        //bottom: 20.0,
                      ),
                      child: TextField(//
                        controller: _passwordController,
                        // once the user start typing , will pass the enterd to _validatePassword 
                        onChanged: _validatePassword,
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
                              color: Colors.grey, // Default color when its empty 
                            ),
                          ),
                          // enabledBorder : when the filed not active 
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              // Color enabled based on validity or emptiness
                              color: _passwordController.text.isEmpty
                                  ? Colors.grey // if empty 
                                  : isPasswordValid
                                      ? Color(0xff00A79D) // if valid 
                                      : Colors.red, 
                            ),
                          ),
                          // focusedBorder : when the filed active (start typing)
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: _passwordController.text.isEmpty
                                  ? Colors.grey
                                  : isPasswordValid
                                      ? Color(0xff00A79D)
                                      : Colors
                                          .red, 
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


                    // conditions for error messages 
                    //if the password not valid 
                    if (!isPasswordValid && _passwordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 15, left: 8.0),
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
                        //top: 20.0,
                      ),


                      // confermation password 

                      child: TextField(
                        controller: _confirmPasswordController,

                        // once the user start typing , will pass the enterd to _validatePasswordConfirmation to check if match 
                        onChanged: _validatePasswordConfirmation,
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
                              color: Colors.grey, 
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
                                          .red, 
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


                    // check if the two passwords are matching 

                    if (!doPasswordsMatch &&
                        _confirmPasswordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 15.0, right: 60.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '  ! كلمة المرور غير متطابقة  *',
                            textAlign: TextAlign.right,
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
                        //once the user press the butten :
                        // will check if the two Controller are not empty and valid and match each other 

                        onPressed: (_passwordController.text.isNotEmpty &&
                                _confirmPasswordController.text.isNotEmpty &&
                                isPasswordValid &&
                                doPasswordsMatch)
                            ? () async {
                              // if yes will reset the password 
                                await _resetPassword(
                                  _passwordController.text,
                                );
                                _showResetPassDialog(context);
                              }
                             // if not do nothing ( the button is disabled )
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
                          primary: (isPasswordValid && doPasswordsMatch)
                              ? Color(0xff00A79D)
                              : Color(0xff00A79D),
                              onSurface: Color(0xff00A79D),
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


// dialog that shown after the Reset is successfully done 

  void _showResetPassDialog(BuildContext context) {
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
                "تم تغيير كلمة المرور بنجاح",
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninPage(),//will navigate to sign in page 
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