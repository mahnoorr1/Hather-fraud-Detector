import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/RequestDetailes1Page.dart';
import 'package:flutter_application_2/HomePage.dart';
import 'package:flutter_application_2/SendNewRequest.dart';
import 'package:flutter_application_2/RequestDetailes2Page.dart';
import 'package:flutter_application_2/SettingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This page make the user go to send a new request page, or display a list of all the requists that are gnerated by the user 

class RequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user == null) {
      // Handle the case where the user is not authenticated
      // You can navigate to a login page or show an error message.
      return Center(child: Text('User is not authenticated.'));
    }
    // Retrieve the user's UID, to know the current user 
    String currentUserId = user.uid; 

    //requists collection in the firebase
    CollectionReference requestsCollection = FirebaseFirestore.instance.collection('Requests');

    return Container(
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
      child: Scaffold(
        //cheke in the firebase requestsCollection if the user have any requists if not it will show 'لا توجد طلبات', "طلب جديد"
        backgroundColor: Colors.transparent,
        body: StreamBuilder<QuerySnapshot>(
          stream: requestsCollection
              .where('UserId', isEqualTo: currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لا توجد طلبات',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendNewRequest(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(
                              "طلب جديد",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IBMPlexSansArabic',
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.add_box,
                            color: Colors.white,
                            size: 33,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return SafeArea(
              //faiding background
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
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 80),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 40.0, left: 300),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SendNewRequest(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Text(
                                              "طلب جديد",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'IBMPlexSansArabic',
                                                fontSize: 30,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.add_box,
                                            color: Colors.white,
                                            size: 33,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // coulmn contain list of requist 
                              Column(
                                //it will take the content from firebase and display it 
                                children: snapshot.data!.docs.map((document) {
                                  final title = document['Title'];
                                  final requestId = document['RequestID'];
                                  final response = document['Response'];
                                  final content = document['Content'];
                                  return RequestBox(
                                    title: title,
                                    requestId: requestId, 
                                    response: response,
                                    content: content,
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
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
                          MaterialPageRoute(
                              builder: (context) => RequestsPage()),
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
      ),
    );
  }
}

class RequestBox extends StatelessWidget {
  // Declare the instance variables
  final String title;
  final String requestId;
  final String response;
  final String content;

  RequestBox(
      {required this.title,
      required this.requestId,
      required this.response,
      required this.content});

//navigate to RequestDetailes2Pageو state 'تحت المعالجة'
  void navigateTo2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestDetailes2Page(
          title: title,
          requestId: requestId,
          response: response,
          content: content,
        ),
      ),
    );
  }

//navigate to RequestDetailes1Pageو state 'تمت المعالجة'
  void navigateTo1(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestDetailes1Page(
          title: title,
          requestId: requestId,
          response: response,
          content: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the state text based on whether 'response' is empty or not
    String stateText = response.isNotEmpty ? "تمت المعالجة" : "تحت المعالجة"; 
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color.fromRGBO(0, 167, 157, 0.99),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              border: Border.all(
                color: Color.fromRGBO(0, 167, 157, 0.99),
                width: 2.0,
              ),
            ),
            // Container for the title
            child: Center(
              child: Text(
                title, //title
                style: TextStyle(
                  color: Color(0xff262262),
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Container for buttons and state text
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //navegation methods
                    if (response.isEmpty) {
                      navigateTo2(context);
                    } else {
                      navigateTo1(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(0, 167, 157, 0.99),
                  ),
                  child: Text(
                    "التفاصيل",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 25,
                    ),
                  ),
                ), //
                Row(
                  children: [
                    Text(
                      stateText, // show the state type
                      style: TextStyle(
                        color: response.isNotEmpty
                            ? Color.fromRGBO(0, 167, 157, 0.99) // 'تمت المعالجة'
                            : Colors.red, // 'تحت المعالجة'
                        fontSize: 20,
                        fontFamily: 'IBMPlexSansArabic',
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 12,
                      height: 12,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff262262),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}