import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/HomePage.dart';
import 'package:flutter_application_2/RequestsPage.dart';
import 'package:flutter_application_2/SettingsPage.dart';

// This page make the user able to send a new request if they need

class SendNewRequest extends StatefulWidget {
  @override
  _SendNewRequestState createState() => _SendNewRequestState();
}

class _SendNewRequestState extends State<SendNewRequest> {
  // controllers to save the content of (title & detailes)
  final titleController = TextEditingController();
  final detailsController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //faiding background
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
          //page content
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 30),
                        IconButton(
                          iconSize: 33,
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 220),
                        Text(
                          'طلب جديد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Column(
                  children: [
                    Row(
                     // Request title input field
                      children: [
                        Expanded(
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Color.fromRGBO(0, 167, 157, 0.99),
                                width: 2.0,
                              ),
                            ),
                            child: TextFormField(
                              controller: titleController, //save the input title in this controller
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontFamily: 'IBMPlexSansArabic',
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16.0),
                                hintText: 'عنوان الطلب',
                                hintStyle: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white70,
                                  fontFamily: 'IBMPlexSansArabic',
                                ),
                                hintTextDirection: TextDirection
                                    .rtl, // Right-to-left text direction
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),//space
                    // Request details input fields
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        controller: detailsController, //save the input detailes in this controller
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontFamily: 'IBMPlexSansArabic',
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(16.0),
                          hintText: ' اكتب تفاصيل طلبك هنا...',
                          hintStyle: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                          border: InputBorder.none,
                          hintTextDirection: TextDirection.rtl, // Right-to-left text direction
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    //send botton
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle the button click
                            _saveRequestToFirestore(); //save to firebase 
                            _showRequestSentDialog(context); // dialog appeare to the screen to inform the user that the requist is send
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(0, 167, 157, 0.99),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'إرسال',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'IBMPlexSansArabic',
                              ),
                            ),
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
      // Bottom Navigation Bar 
      bottomNavigationBar: Container(
        height: 100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(45.0),
            ),
          ),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.home_outlined),
                    iconSize: 50,
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
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.message_outlined),
                    iconSize: 45,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RequestsPage()),
                      );
                    },
                  ),
                  Icon(
                    Icons.fiber_manual_record,
                    size: 15,
                    color: Color(0xff00A79D),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.settings_outlined),
                    iconSize: 45,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
 
 //some helping methods

 // dialog appeare to the screen to inform the user that the requist is send
 //we call it when the user onpress "ارسال"
  void _showRequestSentDialog(BuildContext context) {
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
                "تم إرسال الطلب بنجاح",
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
                    Navigator.pop(context);
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

  //method that will save the content that entered by the user in the firebase
  void _saveRequestToFirestore() async {
    // Get the title and details from the text controllers
    String title = titleController.text;
    String content = detailsController.text;

    try {
      // Reference the "Requests" collection and add a new document

      // 1. Get the current user's UserID.
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;
      if (user != null) {
        String currentUserId = user.uid;

        // 2. Create a unique RequestID.

        String requestID = DateTime.now().millisecondsSinceEpoch.toString();

        // 3. Insert the data into the Requests collection.
        CollectionReference requestsCollection =
            FirebaseFirestore.instance.collection('Requests');

        await requestsCollection.add({
          // 'AdminPhone': '',
          'Content': content,
          'RequestID': requestID,
          'Response': '',
          // 'State': 'تحت المعالجة',
          'Title': title,
          'UserId': currentUserId,
        });

        // The request data is now added to the Requests collection.
      }
      // Clear the title and details controllers after the document has been added
      titleController.clear();
      detailsController.clear();
    } catch (e) {
      // Handle any errors that may occur during the Firestore operation
      print('Error adding document to Firestore: $e');
    }
  }
}