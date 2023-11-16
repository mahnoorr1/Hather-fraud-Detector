import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/AdminPages/RequestsPageAdmin.dart';
import 'package:flutter_application_2/SigninPage.dart';
import 'RequestsPageAdminWithResponse.dart';

// The RequestsDetails class represents the details page for a specific user request.
// It displays information about the request, allows the admin to provide a response,
// and includes a bottom navigation bar for navigation within the admin interface.
class RequestsDetails extends StatefulWidget {
  final String title;
  final String requestId;
  final String content;
  final String userid;

// Constructor to initialize the request details.
  RequestsDetails({
    required this.title,
    required this.requestId,
    required this.content,
    required this.userid,
  });

  @override
  _RequestsDetailsState createState() => _RequestsDetailsState();
}

// The _RequestsDetailsState class is the state class for the RequestsDetails widget.
// It manages the state, UI, and functionality of the RequestsDetails page.
class _RequestsDetailsState extends State<RequestsDetails> {
  // Controller for handling the response input field.
  final responseController = TextEditingController();

  @override
  void dispose() {
    responseController.dispose();
    super.dispose();
  }

// Build the UI for the RequestsDetails page.
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
                            builder: (context) => RequestsPageAdmin(),
                          ),
                        );
                      },
                    ),
                    Spacer(),
                    Text(
                      widget.title,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Display user details and request content.
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
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.userid,
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

                    // Stack containing the response input and send button.
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 30,
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 10),
                              Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.content,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: TextFormField(
                                  controller: responseController,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.grey,
                                    fontFamily: 'IBMPlexSansArabic',
                                  ),
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(16.0),
                                    hintText: 'قم بالرد هنا',
                                    hintStyle: TextStyle(
                                      fontSize: 25,
                                      color: Colors.grey,
                                      fontFamily: 'IBMPlexSansArabic',
                                    ),
                                    border: InputBorder.none,
                                    hintTextDirection: TextDirection.rtl,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 170.0,
                                  vertical: 60.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _showConfirmationDialog();
                                        _updateResponseToFirebase();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromRGBO(0, 167, 157, 0.99),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 50,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        "ارسال",
                                        style: TextStyle(
                                          fontFamily: 'IBMPlexSansArabic',
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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

      // Bottom navigation bar for admin actions.
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
                          builder: (context) => RequestsPageAdmin(),
                        ),
                      );
                    },
                  ),
                  Icon(
                    Icons.fiber_manual_record,
                    size: 15, //
                    color: Color(0xff00A79D),
                  ),
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

// Update the response to Firebase based on user input.
  void _updateResponseToFirebase() {
    String response = responseController.text;

    CollectionReference requestsCollection =
        FirebaseFirestore.instance.collection('Requests');

// Extract response text and update Firestore
    requestsCollection
        .where('RequestID', isEqualTo: widget.requestId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var documentReference = querySnapshot.docs[0].reference;
        documentReference.update({
          'Response': response,
        }).then((value) {
          print('Response updated successfully');
          responseController.clear();
        }).catchError((error) {
          print('Error updating response: $error');
        });
      } else {
        print('Document not found with RequestID: ${widget.requestId}');
      }
    }).catchError((error) {
      print('Error searching for the document: $error');
    });
  }

// Display a confirmation dialog after sending the response.
  void _showConfirmationDialog() {
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
                "تم إرسال الرد بنجاح",
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
                        builder: (context) => const RequestsPageAdmin(),
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

  // Display a logout confirmation dialog.
  void _logoutWidget(BuildContext context) {
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
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
}