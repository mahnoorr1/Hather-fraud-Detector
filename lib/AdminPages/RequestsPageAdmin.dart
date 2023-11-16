import 'package:flutter/material.dart';
import 'package:flutter_application_2/AdminPages/RequestsDetailsWithResponse.dart';
import 'package:flutter_application_2/AdminPages/RequestsDetails.dart';
import 'package:flutter_application_2/AdminPages/RequestsPageAdminWithResponse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/SigninPage.dart';

class RequestsPageAdmin extends StatefulWidget {
  const RequestsPageAdmin({Key? key}) : super(key: key);
  @override
  _RequestsPageAdminState createState() => _RequestsPageAdminState();
}

// The RequestsPageAdmin class represents the main page for handling and displaying admin requests.
class _RequestsPageAdminState extends State<RequestsPageAdmin> {
  late QuerySnapshot requestSnapshot;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

// Asynchronous method to fetch requests from Firestore.
  Future<void> fetchRequests() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Requests')
        .where('Response', isEqualTo: '')
        .get(); // Filter requests without responses
    setState(() {
      requestSnapshot = snapshot;
    });
  }

// Build method constructs the UI of the RequestsPageAdmin.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF262262),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
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
              ),
              Positioned(
                top: 120,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'قائمة الطلبات',
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'IBMPlexSansArabic',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 250,
                left: 0,
                right: 0,
                bottom: 0,
                child: requestSnapshot == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: requestSnapshot.size,
                        itemBuilder: (context, index) {
                          final request = requestSnapshot.docs[index];
                          final title = request['Title'];
                          final requestId = request['RequestID'];
                          final response = request['Response'];
                          final content = request['Content'];
                          final userid = request['UserId'];

                          return Container(
                            margin: EdgeInsets.only(
                                bottom: 15.0), // Add vertical spacing here
                            child: RequestBox(
                              title: title,
                              requestId: requestId,
                              response: response,
                              content: content,
                              userid: userid,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),

        // Bottom navigation bar for navigating within the admin interface.
        bottomNavigationBar: Container(
          height: 100,
          child: Container(
            //
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(45.0)),
            ),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.message_outlined),
                      iconSize: 50,
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RequestsPageAdmin()),
                        );
                      },
                    ),
                    Icon(Icons.fiber_manual_record,
                        size: 15, color: Color(0xff00A79D)),
                  ],
                ),
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
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      iconSize: 45,
                      color: Colors.black,
                      onPressed: () {
                        _logoutWdgit(context);
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

// Method to display a logout confirmation dialog.
void _logoutWdgit(BuildContext context) {
  double customWidth = 328.0;
  double customHeight = 410.0;

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

// The RequestBox class represents the individual request box displayed in the list.
class RequestBox extends StatelessWidget {
  final String title;
  final String requestId;
  final String response;
  final String content;
  final String userid;

  RequestBox({
    required this.title,
    required this.requestId,
    required this.response,
    required this.content,
    required this.userid,
  });
  // Method to navigate to the detailed request page.
  void navigateTo2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestsDetails(
          title: title,
          requestId: requestId,
          content: content,
          userid: userid,
        ),
      ),
    );
  }

  // Method to navigate to the detailed response page.
  void navigateTo1(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestsDetailsWithResponse(
          title: title,
          requestId: requestId,
          response: response,
          content: content,
          userid: userid,
        ),
      ),
    );
  }

// Build method constructs the UI of the RequestBox.
  @override
  Widget build(BuildContext context) {
    String stateText = response.isNotEmpty ? "تمت المعالجة" : "تحت المعالجة";
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(
                color: Color.fromRGBO(0, 167, 157, 0.99),
                width: 2.0,
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xff262262),
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
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
                ),
                Row(
                  children: [
                    Text(
                      stateText,
                      style: TextStyle(
                        color: response.isNotEmpty
                            ? Color.fromRGBO(0, 167, 157, 0.99)
                            : Colors.red,
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