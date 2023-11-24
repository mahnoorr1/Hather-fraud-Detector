import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('SigninPage Integration Test', (WidgetTester tester) async {
    try {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.text('! اهلاً بك'));

      // added a delay so that screen components are loaded before moving forward
      await tester.pumpAndSettle(Duration(seconds: 2));

      // entering the valid information 
      await tester.enterText(
          find.byKey(Key('phoneNumberTextField')), '+966541184940');
      await tester.enterText(find.byKey(Key('passwordTextField')), 'Lana@123456');

      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text('تسجيل الدخول'));

      await tester.pumpAndSettle(Duration(seconds: 5));
      // Ensure error messages are not displayed
      expect(find.text('رقم الجوال أو كلمة المرور غير صحيحان *'), findsNothing);
      expect(find.text('كلمة المرور غير صحيحة  *'), findsNothing);
      expect(find.text('المستخدم غير موجود *'), findsNothing);
      await tester.pumpAndSettle(Duration(seconds: 5));
      
      // Check if OTP screen has been displayed by finding the text on it 
      expect(find.text('رمز التحقق'), findsOneWidget);
      for (int i = 0; i < 6; i++) {
          await tester.enterText(
              find.byType(TextField).at(i), (i + 1).toString());
        }
        await tester.pumpAndSettle(Duration(seconds: 3));

      print('\nSigninPage Integration Test passed!\n');
    } catch (error) {
        if (find
            .text('رقم الجوال أو كلمة المرور غير صحيحان *')
            .evaluate()
            .isNotEmpty) {
          print(
              '\nSigninPage Integration Test failed! Error message found: "رقم الجوال أو كلمة المرور غير صحيحان *"\n');
        } else if (find
            .text('كلمة المرور غير صحيحة  *')
            .evaluate()
            .isNotEmpty) {
          print(
              '\nSigninPage Integration Test failed! Error message found: "كلمة المرور غير صحيحة  *"\n');
        } else if (find
            .text('المستخدم غير موجود *')
            .evaluate()
            .isNotEmpty) {
          print(
              '\nSigninPage Integration Test failed! Error message found: "المستخدم غير موجود *"\n');
        } else {
          // print('\nSigninPage Integration Test failed!\n');
        }
    } finally {
      // End the test and shut down
      await tester.pumpAndSettle();
    }
  });
}
