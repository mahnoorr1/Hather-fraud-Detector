import 'package:flutter/material.dart';
import 'package:flutter_application_2/SettingsPage.dart';

// This is the PrivacyPolicy page, which displays the privacy policy information of Hather app.

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Scaffold(
        backgroundColor: Color(0xFF262262), //Background color
        body: Stack(
          children: [
            //fading background
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

            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 120, horizontal: 25),
                    ),
                    SizedBox(width: 20),
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
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 110),
                    Text(
                      'سياسة الخصوصية ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35, // Customize font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ), //
                Expanded(
                  child: Align(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, right: 50.0, left: 50.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: 'IBMPlexSansArabic',
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              'من فضلك اقرأ سياسة الخصوصية التالية لفهم كيفية جمع واستخدام وحفظ ومشاركة معلوماتك عند استخدام التطبيق.\n\n\n',
                                        ),
                                        TextSpan(
                                          text: ' جمع المعلومات:\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        buildBulletPoint(
                                            'يتم جمع بعض المعلومات التشخيصية التي ترتبط بجهازك واستخدامك للتطبيق تلقائيًا\n'),
                                        buildBulletPoint(
                                            'نحن نطلب إذنك قبل جمع أو مشاركة أي معلومات شخصية.'),
                                        TextSpan(
                                          text: '\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: ' استخدام المعلومات:\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        buildBulletPoint(
                                            ' لا نقوم ببيع أو مشاركة معلوماتك الشخصية مع أطراف ثالثة دون إذنك.\n'),
                                        buildBulletPoint(
                                            'نحن نستخدم المعلومات التي نجمعها لتحسين أداء التطبيق وتقديم خدمات أفضل لك'),
                                        TextSpan(
                                          text: '\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          //
                                          text: 'حقوق الوصول:\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        buildBulletPoint(
                                            'إذا كنت بحاجة إلى مساعدة في ذلك، يُرجى الاتصال بفريق الدعم لدينا.\n'),
                                        buildBulletPoint(
                                            'يمكنك دائمًا الوصول إلى معلوماتك الشخصية من خلال إعدادات التطبيق'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
  }

  TextSpan buildBulletPoint(String text) {
    return TextSpan(
      text: '• $text\n',
    );
  }
}