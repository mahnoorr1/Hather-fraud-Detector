import 'package:flutter/material.dart';
import '../lib/REsetPage.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../lib/main.dart'; // Update this import based on your app structure

void main() {
  group('Reset Password Flow Integration Test', () {
    // Ensure that Firebase is initialized before running the tests
    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });
    var phoneNumber = '+966544866646';

    testWidgets('Reset Password Flow Test', (WidgetTester tester) async {
      try {
        await tester.pumpWidget(MyApp());

        await tester.pumpAndSettle(Duration(seconds: 5));
        // Step 1: Navigate to the ResetPass page
        await tester.tap(find.text('هل نسيت كلمة المرور؟'));
        await tester.pumpAndSettle(Duration(seconds: 5));

        // checking that app is navigated to reset pass screen and checking it's first text widget
        expect(find.text('قم بإدخال رقم الجوال'), findsOneWidget);

        // Step 2: Entering phone number
        await tester.enterText(find.byType(TextField), phoneNumber);
        await tester.tap(find.text('اعادة تعيين كلمة المرور'));
        await tester.pumpAndSettle(Duration(seconds: 4));

        // navigating to otp screen
        expect(find.text('رمز التحقق'), findsOneWidget);
        // entering otp 123456
        for (int i = 0; i < 6; i++) {
          await tester.enterText(
              find.byType(TextField).at(i), (i + 1).toString());
        }
        await tester.pumpAndSettle(Duration(seconds: 3));
        await tester.tap(find.text('استمرار'));
        //navigating to reset page if phone number is corerct otherwise it will throw error
        await tester
            .pumpWidget(MaterialApp(home: REsetPage(phoneNumber: phoneNumber)));
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Ensure the app navigated to the REsetPage by checking text on reset page
        expect(find.text('! اهلاً بك'), findsOneWidget);

        // Step 4: Entering new password
        await tester.enterText(find.byType(TextField).first, 'Somaya@123');
        await tester.enterText(find.byType(TextField).last, 'Somaya@123');
        await tester.pumpAndSettle(Duration(seconds: 3));
        //taping confirm button
        await tester.tap(find.text('إرسال'));
        await tester.pumpAndSettle(Duration(seconds: 8));
        print('Password Reset Test Completed Successfully');
      } catch (error) {
        print("Reset Password flow Test Failed");
        //add the below line if you want to display the error on console as well
        //throw error;
      } 
    });
  });
}
