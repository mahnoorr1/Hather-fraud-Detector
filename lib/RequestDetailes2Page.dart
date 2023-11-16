import 'package:flutter/material.dart';
import 'package:flutter_application_2/HomePage.dart';
import 'package:flutter_application_2/RequestsPage.dart';
import 'package:flutter_application_2/SettingsPage.dart';

// This page displays the detailed information about a specific request. for (تحت المعالجة) Request status  
// It includes the request title, content and status.

class RequestDetailes2Page extends StatelessWidget {
  // Declare the instance variables
  final String title;
  final String requestId;
  final String response;
  final String content;

  //constructor 
  RequestDetailes2Page(
      {required this.title,
      required this.requestId,
      required this.response,
      required this.content});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262262),
      body: SafeArea(
        //fading background
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
                0.0,
                0.45,
                0.6,
                0.8,
                1.0
              ], // More stops for smoother fading
              colors: [
                Color.fromRGBO(0, 167, 157, 0.99), // opacity
                Color(0xFF262262),
                Color(0xFF262262),
                Color(0xFF262262),
                Color(0xFF262262),
              ],
            ),
          ),
          // Page content
          child: ListView(
            children: [
              // Request title and back arrow
              Padding(
                padding: EdgeInsets.symmetric(vertical: 70, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 30),
                        //arrow back icon to go to the back page
                        IconButton(
                          iconSize: 33,
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(//
                                builder: (context) => RequestsPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 220),
                        Text(
                          title, //Request title
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
              // Request details (content & status)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Stack(
                  children: [
                    // Request (content)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10), // Space
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                15.0), // Make the box curved
                          ),
                          child: Center(
                            child: Text(
                              content, // (content)
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IBMPlexSansArabic',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(height: 8),
                        // Request status (تحت المعالجة)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // To align items to the right
                          children: [
                            Container(
                              alignment:
                                  Alignment.topRight, // Align text to the right
                              child: Text(
                                "تحت المعالجة ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 25,
                                  fontFamily: 'IBMPlexSansArabic',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Container(
                              alignment:
                                  Alignment.topRight, // Align text to the right
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                ": حالة الطلب ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 25,
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                ], //
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
}