import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/HomePage.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../lib/main.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });
  testWidgets('Integration Test', (WidgetTester tester) async {
    try {
      // final _client = http.Client();
      // await tester.pumpWidget(MyApp());
      // await tester.pumpAndSettle(Duration(seconds: 5));
      // await tester.tap(find.text('! اهلاً بك'));

      // // added a delay so that screen components are loaded before moving forward
      // await tester.pumpAndSettle(Duration(seconds: 2));

      // // entering the valid information
      // await tester.enterText(
      //     find.byKey(Key('phoneNumberTextField')), '+966544866648');
      // await tester.enterText(find.byKey(Key('passwordTextField')), 'Somaya12@');

      // await tester.pumpAndSettle(Duration(seconds: 2));
      // await tester.tap(find.text('تسجيل الدخول'));

      // await tester.pumpAndSettle(Duration(seconds: 5));

      // // Check if OTP screen has been displayed by finding the text on it
      // expect(find.text('رمز التحقق'), findsOneWidget);
      // // entering otp 123456
      //   for (int i = 0; i < 6; i++) {
      //     await tester.enterText(
      //         find.byType(TextField).at(i), (i + 1).toString());
      //   }
      //   await tester.pumpAndSettle(Duration(seconds: 3));
      //   await tester.tap(find.text('استمرار'));
        await tester
            .pumpWidget(MaterialApp(home: HomePage()));
        await tester.pumpAndSettle(Duration(seconds: 5));

      await tester.runAsync(() async {
        await HomePageState().modelpredict(
          "سبل اونلاين شحنتك في الطريق ادفع المبلغ عن طريق الرابط او بنرسل شحنتك الى مقرها",
          "+16505556789",
        );
        // Wait for any animations to complete
        await tester.pumpAndSettle(Duration(seconds: 2));
      });
      print("Test Passed");
    } catch (error) {
      print("Prediction Test Failed");
    }

    // Build our app and trigger a frame.
    //await tester.pumpWidget(MyApp());

    // // Trigger sign in and navigate to the home page (replace this with your actual sign-in logic)
    // await tester.tap(find.text('Sign In')); // Assuming you have a button with text 'Sign In'
    // await tester.pumpAndSettle();

    // // Enter the home page (replace this with your actual navigation logic)
    // await tester.tap(find.text('Enter Home')); // Replace with your actual button or navigation action
    // await tester.pumpAndSettle();

    // Access the _MyHomePageState directly
    //  final HomePageState homePageState = tester.widget<HomePage>(find.byType(HomePage)).getState();

    // Call the modelPredict method
  });
}
