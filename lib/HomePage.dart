import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter_application_2/SettingsPage.dart';
import 'RequestsPage.dart';
import 'package:flutter_sms_listener/flutter_sms_listener.dart'; //access
import 'package:http/http.dart' as http; //model
import 'dart:convert'; //model
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:math';

final _client = http.Client(); //mpdel

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
  HomePageState getState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
   static const Key _homePageStateKey = Key('_HomePageStateKey');
  static Key get homePageStateKey => _homePageStateKey;
  
  static const String LISTEN_MSG = 'Listening to sms...'; //access
  static const String NEW_MSG = 'Captured new message!'; //access
  String _status = LISTEN_MSG; //access
  String percentage = '00%';
  int counter = 0;

  FlutterSmsListener _smsListener = FlutterSmsListener(); //access
  List<SmsMessage> _messagesCaptured = <SmsMessage>[]; //access

  PageController _pageController = PageController();
  int _currentPage = 0;
  List<String> _messages = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchMessagesFromDatabase(); //awarness messages
    _startAutoScroll();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _beginListening(); //access
    });
  }

//to display notification when invalid message detected
  void displayNotification(int counter) {
    String notificationBody;

    if (counter == 1) {
      notificationBody = 'لديك رسالة احتيال جديدة';
    } else if (counter == 2) {
      notificationBody = 'لديك رسالتان احتيال جديدة';
    } else if (counter >= 3 && counter <= 10) {
      notificationBody = 'لديك $counter رسائل احتيال جديدة';
    } else {
      notificationBody = 'لديك $counter رسالة احتيال جديدة';
    }

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1, // Unique notification ID
        channelKey: 'basic_channel',
        title: 'تنبيه!!',
        body: notificationBody,
      ),
    );
  }

//fetch the Awareness_Messages to show to user in home page
  Future<void> _fetchMessagesFromDatabase() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Awareness_Messages')
          .doc('uO0kxcWgsv8kpaHOx4eW') // Specifying the document ID
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        List<String> messages = [];

        // Iterate through the fields and add the string values to the messages list
        data.forEach((key, value) {
          if (value is String) {
            messages.add(value);
          }
        });

        setState(() {
          _messages = messages;
        });
      }
    } catch (error) {
      print("Error fetching messages: $error");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

//to auto scroll the Awareness_Messages
  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < _messages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

//client side for the model predict
  Future<void> modelpredict(String input, String address) async {
    print("Prediction model called!");

    try {
      // Send a POST request to the Python server with the captured message body as input
      final response = await _client.post(Uri.parse("http://127.0.0.1:13000/modelpredict?input=$input")); //////////change the ip 

      print('My input is ++++ $input');

      if (response.statusCode == 200) {
        // If the request was successful (status code 200), parse the JSON response
        final responseDecoded = jsonDecode(response.body);

        // Access the prediction result from the response
        final predictionResult = responseDecoded["prediction_result"];

        // Access the percentage result from the response
        final percentResult = responseDecoded["prediction"];

        // Print the prediction result
        print("Prediction Result: $predictionResult");

        // Print the percentage result
        print("Percentage Result: $percentResult");
        int percent = (percentResult * 100).toInt();
        percentage = percent.toStringAsFixed(0);
        //percentage = (percentResult * 100).toString();
        print("Raw Prediction Value after * 100: $percentage ");

        if (predictionResult == "Invalid") {
          try {
            // 1. Get the current user's UserID.
            final FirebaseAuth _auth = FirebaseAuth.instance;
            final User? user = _auth.currentUser;
            if (user != null) {
              String currentUserId = user.uid;

              // 2. Create a unique MessageID.
              String MessageID =
                  DateTime.now().millisecondsSinceEpoch.toString();

              // 3. Insert the data into the Message collection.
              CollectionReference MessageCollection =
                  FirebaseFirestore.instance.collection('Message');

              await MessageCollection.add({
                'MessageContent': input,
                'MessageID': MessageID,
                'uid': currentUserId,
                'MessageState': "",
                'Percent': percentage,
                'Source': address,
              });

              // 4. Send a notification with a unique ID

              // notification with counter
              counter++;
              displayNotification(counter);
            }
          } catch (e) {
            // Handle any errors that may occur during the Firestore operation
            print('Error adding document to Firestore: $e');
          }
        }
      } else {
        // Handle errors or invalid responses here
        print("Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors) here
      print("Error: $e");
    }
  }

  //access method Listening to sms
  void _beginListening() {
    _smsListener.onSmsReceived!.listen((message) {
      _messagesCaptured.add(message);

// Access the sender's address (phone number)
      String? address = message.address;

      // Print the captured message content to the terminal
      print("Captured Message: ${message.body}");

      // Use the captured message body for prediction as an input
      modelpredict(message.body.toString(), address.toString());

      setState(() {
        _status = NEW_MSG;
      });

      Future.delayed(Duration(seconds: 5)).then((_) {
        setState(() {
          _status = LISTEN_MSG;
        });
      });
    });
  }

//get only detected messages with fraud state
  Stream<QuerySnapshot> getFilteredMessagesStream() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    if (user != null) {
      String currentUserId = user.uid;
      return FirebaseFirestore.instance
          .collection('Message')
          .where('uid', isEqualTo: currentUserId)
          .where('MessageState', whereIn: ['', 'Fraud']).snapshots();
    } else {
      // Return an empty stream if the user is not authenticated
      return Stream.empty();
    }
  }

//update message/s state to fraud when user decide
  Future<void> updateFRAUDMessageState(String messageID) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference messageCollection =
          FirebaseFirestore.instance.collection('Message');

      // Query for documents with the specified MessageID
      QuerySnapshot querySnapshot = await messageCollection
          .where('MessageID', isEqualTo: messageID)
          .get();

      // Update MessageState to "Fraud" for all matching documents
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        await document.reference.update({'MessageState': 'Fraud'});
      }
    } catch (e) {
      // Handle any errors that may occur during the Firestore operation
      print('Error updating MessageState: $e');
    }
  }

//update the message's state to reprted when user report to 330330
  Future<void> updateREPORTEDMessageState(String messageID) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference messageCollection =
          FirebaseFirestore.instance.collection('Message');

      // Query for documents with the specified MessageID
      QuerySnapshot querySnapshot = await messageCollection
          .where('MessageID', isEqualTo: messageID)
          .get();

      // Update MessageState to "reported" for all matching documents
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        await document.reference.update({'MessageState': 'Reported'});
      }
    } catch (e) {
      // Handle any errors that may occur during the Firestore operation
      print('Error updating MessageState: $e');
    }
  }

//update the message's state to safe when user decide
  Future<void> updateSAFEMessageState(String messageID) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference messageCollection =
          FirebaseFirestore.instance.collection('Message');

      // Query for documents with the specified MessageID
      QuerySnapshot querySnapshot = await messageCollection
          .where('MessageID', isEqualTo: messageID)
          .get();

      // Update MessageState to "safe" for all matching documents
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        await document.reference.update({'MessageState': 'Safe'});
      }
    } catch (e) {
      // Handle any errors that may occur during the Firestore operation
      print('Error updating MessageState: $e');
    }
  }

//redirect the user to message App with the fraud message and its content to report it
  void _openMessagingApp(String messageContent, String phone) async {
    final encodedMessageContent = Uri.encodeComponent(messageContent);
    final encodedMessageSource = Uri.encodeComponent(phone);
    final url =
        'sms:330330?body=$encodedMessageContent - $encodedMessageSource';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  Color.fromRGBO(
                      0, 167, 157, 0.99), // 70% opacity for Color(0xFF00A79D)
                  Color(0xFF262262),
                  Color(0xFF262262),
                  Color(0xFF262262),
                  Color(0xFF262262),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 410,
                          left: 20,
                          right: 20,
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  height: 2,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0,
                                ),
                                child: Text(
                                  'رسائل الإحتيال',
                                  style: TextStyle(
                                    fontSize: 34.0,
                                    color: Colors.white,
                                    fontFamily: 'IBMPlexSansArabic',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  height: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // PageView with messages
                        Center(
                          child: Container(
                            height: 200,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                return _buildWhiteContainer(_messages[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 1, // Show only 1 item
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            _buildVerticalListItem(),
                            SizedBox(height: 130),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
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

  Widget _buildWhiteContainer(String content) {
    return Container(
      width: 305,
      height: 137,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff262262),
              fontFamily: 'IBMPlexSansArabic',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

//boxes for detected messages
  Widget _buildVerticalListItem() {
    return StreamBuilder<QuerySnapshot>(
      stream: getFilteredMessagesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text(
                  'لم تصلك اي رسائل إحتيالية',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        }

        return Column(
          //Retrieve fields to use them
          children: snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            String messageContent = data['MessageContent'];
            String messageID = data['MessageID'];
            String MessageState = data['MessageState'];
            String percentage = data['Percent'];
            String phone = data['Source'];

            bool isFraud = MessageState == 'Fraud';

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 540,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              '$percentage%', //////////////  PERCENTAGE  ////////////////////
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.red,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'IBMPlexSansArabic',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff00A79D),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                phone,
                                style: TextStyle(
                                  fontSize: 23.0,
                                  color: Color(0xff262262),
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'IBMPlexSansArabic',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                  height:
                                      8), // space between the two Text widgets
                              Text(
                                messageContent,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color(0xff262262),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'IBMPlexSansArabic',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: isFraud
                                ? () {
                                    updateREPORTEDMessageState(messageID);
                                    _openMessagingApp(messageContent, phone);
                                  }
                                : () {
                                    _ConfirSafeMessageDialog(
                                        context, messageID);
                                  },
                            style: ElevatedButton.styleFrom(
                              primary: isFraud ? Color(0xff00A79D) : Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(200, 0),
                            ),
                            child: Text(
                              isFraud ? "تبليغ " : "إلغاء",
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'IBMPlexSansArabic',
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: isFraud
                                ? null
                                : () {
                                    _showConfirmationForDetectionDialog(
                                        context, messageID);
                                  },
                            style: ElevatedButton.styleFrom(
                              primary:
                                  isFraud ? Colors.grey : Color(0xff00A79D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(200, 0),
                            ),
                            child: Text(
                              isFraud ? "تم تأكيد الإحتيال" : "تأكيد الإحتيال",
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'IBMPlexSansArabic',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showConfirmationForDetectionDialog(
      BuildContext context, String messageID) {
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
                        TextSpan(text: " أنها رسالة احتيال ؟"),
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
                        Navigator.of(context).pop();

                        updateFRAUDMessageState(messageID);
                        _showAfterConfDialog(context);
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

  void _showAfterConfDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: EdgeInsets.all(16.0), // Adjust the content padding
          title: Column(
            children: [
              Image.asset(
                'assets/images/correct_gif.gif', // Replace with the path to  GIF file
                width: 200.0, // Adjust the width of the GIF as needed
                height: 200.0, // Adjust the height of the GIF as needed
              ),
              SizedBox(height: 15), // Add spacing between the GIF and text
              Text(
                "تم التأكيد بنجاح ",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff262262),
                  fontFamily: 'IBMPlexSansArabic',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _ConfirSafeMessageDialog(BuildContext context, String messageID) {
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
                        TextSpan(text: " أنها رسالة آمنة ؟"),
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
                        Navigator.of(context).pop();

                        updateSAFEMessageState(messageID);
                        _showAfterConfDialog(context);
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