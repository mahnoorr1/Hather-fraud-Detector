import 'package:flutter/material.dart';
import 'package:flutter_application_2/AdminPages/RequestsPageAdmin.dart';
import 'package:flutter_application_2/SigninPage.dart';

import 'RequestsPageAdminWithResponse.dart';

// The RequestsDetailsWithResponse class represents the detailed view of a request with a response.
class RequestsDetailsWithResponse extends StatelessWidget {
  final String title;
  final String requestId;
  final String response;
  final String content;
  final String userid;

// Constructor to initialize the request details.
  RequestsDetailsWithResponse(
      {required this.title,
      required this.requestId,
      required this.response,
      required this.content,
      required this.userid});

  // Build method constructs the UI of the RequestsDetailsWithResponse.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              // Header section with back button and title.
              Padding(
                padding: EdgeInsets.symmetric(vertical: 70, horizontal: 25),
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 33,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RequestsPageAdminWithResponse(),
                          ),
                        );
                      },
                    ),
                    Spacer(),
                    Text(
                      'عنوان الطلب ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansArabic',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    // User ID section.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 50.0),
                                          child: Text(
                                            ': هوية المستخدم',
                                            style: TextStyle(
                                              fontSize: 30.0,
                                              color: Colors.white,
                                              fontFamily: 'IBMPlexSansArabic',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 25),
                                    Center(
                                      child: Container(
                                        width: 500,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ), //
                                        child: Center(
                                          child: Text(
                                            userid,
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              color: Color(0xffC7C9CF),
                                              fontFamily: 'IBMPlexSansArabic',
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
                        ),
                        SizedBox(
                          width: 0,
                        ),
                      ],
                    ),
                    Padding(
                      // Request content and response section.
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 30),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 10),
                              // Container for displaying request content.
                              Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Center(
                                  child: Text(
                                    content,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              // Container for displaying response.
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Text(
                                    response,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Status of the request section.
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "تمت المعالجة ",
                                      style: TextStyle(
                                        color:
                                            Color.fromRGBO(0, 167, 157, 0.99),
                                        fontSize: 25,
                                        fontFamily: 'IBMPlexSansArabic',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      ": حالة الطلب ",
                                      style: TextStyle(
                                        color:
                                            Color.fromRGBO(0, 167, 157, 0.99),
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
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Message icon for navigating back to the main admin page.
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
                            builder: (context) => RequestsPageAdmin()),
                      );
                    },
                  ),
                ],
              ),
              // Checkmark icon for navigating to the response page.
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.check),
                    iconSize: 50,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RequestsPageAdminWithResponse(),
                        ),
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
              // Exit icon for logging out.
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    iconSize: 45,
                    color: Colors.black,
                    onPressed: () {
                      _logoutWidget(context);
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

// Method to display a logout confirmation dialog.
void _logoutWidget(BuildContext context) {
  double customWidth = 328.0;
  double customHeight = 410.0;

// Show a dialog to confirm logout.
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
                  // Button to confirm logout.
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
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigninPage(),
                        ),
                      );
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
                  // Button to cancel logout.
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
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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